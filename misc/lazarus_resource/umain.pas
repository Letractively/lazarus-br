unit umain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  Menus, ComCtrls, StdCtrls, ExtCtrls, LCLType, LResources;

Const Version : string = 'LRS Explorer v 1.0.0';

type

  { TFMain }

  TFMain = class(TForm)
    B_AddRessource: TButton;
    B_DelRessource: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Image1: TImage;
    ImageList1: TImageList;
    ImageListRessourceType: TImageList;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    MenuFile: TMenuItem;
    MenuExit: TMenuItem;
    MenuFrench: TMenuItem;
    MenuEnglish: TMenuItem;
    MenuRus: TMenuItem;
    MenuLangage: TMenuItem;
    MenuListDelete: TMenuItem;
    MenuListAdd: TMenuItem;
    MenuSave: TMenuItem;
    MenuOpen: TMenuItem;
    OpenDialogFile: TOpenDialog;
    OpenDialogLRS: TOpenDialog;
    PopupMenuRessource: TPopupMenu;
    PopupMenuListBox: TPopupMenu;
    SaveDialogRessource: TSaveDialog;
    SaveDialogLRS: TSaveDialog;
    Splitter1: TSplitter;
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    ToolButton1: TToolButton;
    ToolNewFile: TToolButton;
    ToolSave: TToolButton;
    ToolOpen: TToolButton;
    ToolSaveRessource: TToolButton;
    TreeView1: TTreeView;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure Memo1Exit(Sender: TObject);
    procedure MenuEnglishClick(Sender: TObject);
    procedure MenuExitClick(Sender: TObject);
    procedure MenuFrenchClick(Sender: TObject);
    procedure MenuListAddClick(Sender: TObject);
    procedure MenuListDeleteClick(Sender: TObject);
    procedure MenuOpenClick(Sender: TObject);
    procedure MenuRusClick(Sender: TObject);
    procedure MenuSaveClick(Sender: TObject);
    procedure ToolNewFileClick(Sender: TObject);
    procedure ToolSaveRessourceClick(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    Saving : boolean; // The file is saving ?
    InTextLRS : TStringList;
    AppRepertory : String;
    RessourceChange : boolean;
    FileChange : Boolean;
    Appli_Message : array[0..20] of string;
    Procedure LoadLRS;
    Procedure ViewPicture(ResName,extension : string);
    Procedure ViewUnknow(ResName : string);
    Procedure DisableView;
    Procedure deleteRessource(ResName : string);
  end; 

var
  FMain: TFMain;

implementation

{$R *.lfm}

{ TFMain }

//******************************************************************************
function FindResourceInLRS(const ResourceName: string; List: TStrings): integer;
const
  Pattern = 'LazarusResources.Add(''';
var
  Line: string;
  s: String;
begin
  Result:=0;
  while (Result<List.Count) do begin
    Line:=List[Result];
    if (length(Line)>length(Pattern))
    and ((strlcomp(PChar(Line),Pattern,length(Pattern)))=0) then begin
      if (ResourceName='') then
        exit;
      s:=Pattern+ResourceName+''',';
      if (strlcomp(PChar(Line),PChar(s),length(s))=0) then
        exit;
    end;
    inc(Result);
  end;
  Result:=-1;
end;

//******************************************************************************
function ExtractResource(HeaderIndex: integer; LRS: TStrings): TMemoryStream;
var
  i: LongInt;
  p: Integer;
  Line: string;
  StartPos: LongInt;
  CharID: Integer;
  c: Char;
begin
  Result:=TMemoryStream.Create;
  i:=HeaderIndex+1;
  while (i<LRS.Count) do begin
    Line:=LRS[i];
    if (Line<>'') and (Line[1]=']') then exit;// found the end of this resource
    p:=1;
    while (p<=length(Line)) do begin
      case Line[p] of
      '''':
        // string constant
        begin
          inc(p);
          while p<=length(Line) do begin
            if Line[p]<>'''' then begin
              // read normal characters
              StartPos:=p;
              while (p<=length(Line)) and (Line[p]<>'''') do inc(p);
              Result.Write(Line[StartPos],p-StartPos);
            end else if (p<length(Line)) and (Line[p+1]='''') then begin
              // read '
              Result.Write(Line[p],1);
              inc(p,2);
            end else begin
              // end of string constant found
              inc(p);
              break;
            end;
          end;
        end;
      '#':
        // special character
        begin
          inc(p);
          CharID:=0;
          while (p<=length(Line)) and (Line[p] in ['0'..'9']) do begin
            CharID:=CharID*10+ord(Line[p])-ord('0');
            inc(p);
          end;
          c:=chr(CharID);
          Result.Write(c,1);
        end;
      else
        inc(p);
      end;
    end;
    inc(i);
  end;
end;

//******************************************************************************
function StreamIsFormInTextFormat(Stream: TMemoryStream): boolean;
const
  FormTextStart = 'object ';
var s: string;
  OldPos: integer;
begin
  SetLength(s,length(FormTextStart));
  OldPos:=Stream.Position;
  Stream.Read(s[1],length(s));
  Result:=AnsiCompareText(s,FormTextStart)=0;
  Stream.Position:=OldPos;
end;

//******************************************************************************
function StreamIsFormInFCLFormat(Stream: TMemoryStream): boolean;
const
  FormFCLStart = 'TPF0';
var s: string;
  OldPos: integer;
begin
  SetLength(s,length(FormFCLStart));
  OldPos:=Stream.Position;
  Stream.Read(s[1],length(s));
  Result:=s=FormFCLStart;
  Stream.Position:=OldPos;
end;

//******************************************************************************
procedure ConvertFormToText(Stream: TMemoryStream);
var TextStream: TMemoryStream;
begin
  try
    TextStream:=TMemoryStream.Create;
    FormDataToText(Stream,TextStream);
    TextStream.Position:=0;
    Stream.Clear;
    Stream.CopyFrom(TextStream,TextStream.Size);
    Stream.Position:=0;
  except
    on E: Exception do begin
       Application.MessageBox(PCHAR(FMain.Appli_Message[0]+E.Message),PCHAR(FMain.Appli_Message[1]),0);
    end;
  end;
end;

//******************************************************************************
procedure TFMain.FormCreate(Sender: TObject);
begin
  FMain.Caption:=version;
  InTextLRS:=TStringList.Create;
  FMain.Image1.Align:=alClient;
  FMain.Memo1.Align:=alClient;
  AppRepertory:=ExtractFilePath(Application.ExeName);
  FMain.MenuEnglishClick(nil);
end;

//******************************************************************************
procedure TFMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if FMain.FileChange then
    begin
      if Application.MessageBox(PCHAR(FMain.Appli_Message[2]),PCHAR(FMain.Appli_Message[3]),MB_YESNO)=IDYES then
         FMain.MenuSaveClick(nil);
    end;
end;

//******************************************************************************
procedure TFMain.FormDestroy(Sender: TObject);
begin
  InTextLRS.Free;
end;

//******************************************************************************
procedure TFMain.Memo1Change(Sender: TObject);
begin
  FMain.RessourceChange:=True;
  FMain.FileChange:=True;
end;

//******************************************************************************
procedure TFMain.Memo1Exit(Sender: TObject);
var tree : TTreeNode;
    texte,RessourceName : string;
    i : integer;
begin
  if FMain.RessourceChange=True then
    begin
      tree:=FMain.TreeView1.Selected;
      texte:=tree.Text;
      i:=pos('(',texte);
      RessourceName:=copy(texte,1,i-1);
      FMain.deleteRessource(RessourceName);
      for i:=0 to FMain.Memo1.Lines.Count-1 do
          FMain.InTextLRS.Add(FMain.Memo1.Lines.Strings[i]);
    end;
end;

//******************************************************************************
procedure TFMain.MenuEnglishClick(Sender: TObject);
begin
  FMain.MenuFile.Caption:='File';
  FMain.MenuOpen.Caption:='Open';
  FMain.MenuSave.Caption:='Save';
  FMain.MenuLangage.Caption:='Language';
  FMain.MenuExit.Caption:='Exit';
  FMain.MenuListAdd.Caption:='Add';
  FMain.MenuListDelete.Caption:='Delete';
  FMain.OpenDialogLRS.Title:='Open LRS File';
  FMain.OpenDialogFile.Title:='Open File';
  FMain.SaveDialogRessource.Title:='Save current ressource of lrs';
  FMain.SaveDialogLRS.Title:='Save current LRS file';
  FMain.GroupBox1.Caption:='Ressources list';
  FMain.GroupBox2.Caption:='Ressource view';
  Appli_Message[0]:='Unable to convert Delphi form to text: ';
  Appli_Message[1]:='Error';
  Appli_Message[2]:='Your lrs file changed ! Do you want to save it ?';
  Appli_Message[3]:='Attention';
  Appli_Message[4]:='Unable to create file ''';
  Appli_Message[5]:='No ressource name';
  Appli_Message[6]:='Unable to read file ''';
  Appli_Message[7]:='Unable to create temporary file ';
  Appli_Message[8]:='Are you sure, You want to delete the ressource :';
end;

//******************************************************************************
procedure TFMain.MenuExitClick(Sender: TObject);
begin
  FMain.Close;
end;

//******************************************************************************
procedure TFMain.MenuFrenchClick(Sender: TObject);
begin
  FMain.MenuFile.Caption:='Fichier';
  FMain.MenuOpen.Caption:='Ouvrir';
  FMain.MenuSave.Caption:='Sauver';
  FMain.MenuLangage.Caption:='Langue';
  FMain.MenuExit.Caption:='Quitter';
  FMain.MenuListAdd.Caption:='Ajouter';
  FMain.MenuListDelete.Caption:='Supprimer';
  FMain.OpenDialogLRS.Title:='Ouvrir un fichier LRS';
  FMain.OpenDialogFile.Title:='Ouvrir un fichier';
  FMain.SaveDialogRessource.Title:='Sauver la ressource courantedu fichier LRS';
  FMain.SaveDialogLRS.Title:='Sauver le fichier LRS courant';
  FMain.GroupBox1.Caption:='Liste des ressources';
  FMain.GroupBox2.Caption:='Détail de la ressource';
  Appli_Message[0]:='Impossible de convertir une Form Delphi en texte: ';
  Appli_Message[1]:='Erreur';
  Appli_Message[2]:='Votre fichier LRS a changé! Voulez vous sauver les modifications ?';
  Appli_Message[3]:='Attention';
  Appli_Message[4]:='Impossible de créer le fichier ''';
  Appli_Message[5]:='Pas de nom de ressource';
  Appli_Message[6]:='Impossible de lire le fichier ''';
  Appli_Message[7]:='Impossible de créer le fichier temporaire ';
  Appli_Message[8]:='Etes vous sur de vouloir supprimer la ressource :';
end;

//******************************************************************************
procedure TFMain.MenuListAddClick(Sender: TObject);
var FileTemp : TStringList;
    BinFilename,BinExt,ResourceName,ResourceType:String;
    a:integer;
    BinFileStream:TFileStream;
    ResMemStream,BinMemStream:TMemoryStream;
begin
  if FMain.OpenDialogFile.Execute then
     begin
       ResMemStream:=TMemoryStream.Create;
       try
         for a:=0 to FMain.OpenDialogFile.Files.Count-1 do
           begin
             BinFilename:=FMain.OpenDialogFile.Files.Strings[a];
             try
               BinFileStream:=TFileStream.Create(BinFilename,fmOpenRead);
               BinMemStream:=TMemoryStream.Create;
               try
                 BinMemStream.CopyFrom(BinFileStream,BinFileStream.Size);
                 BinMemStream.Position:=0;
                 BinExt:=uppercase(ExtractFileExt(BinFilename));
                 if (BinExt='.LFM') or (BinExt='.DFM') or (BinExt='.XFM') then
                   begin
                     ResourceType:='FORMDATA';
                     ConvertFormToText(BinMemStream);
                     ResourceName:=FindLFMClassName(BinMemStream);
                     if ResourceName='' then
                       begin
                         Application.MessageBox(PCHAR(Appli_Message[5]),PCHAR(Appli_Message[1]),0);
                         exit;
                       end;
                     LFMtoLRSstream(BinMemStream,ResMemStream);
                   end else
                   begin
                     ResourceType:=copy(BinExt,2,length(BinExt)-1);
                     ResourceName:=ExtractFileName(BinFilename);
                     ResourceName:=copy(ResourceName,1
                                          ,length(ResourceName)-length(BinExt));
                     if ResourceName='' then
                       begin
                         Application.MessageBox(PCHAR(Appli_Message[5]),PCHAR(Appli_Message[1]),0);
                         exit;
                       end;
                     BinaryToLazarusResourceCode(BinMemStream,ResMemStream
                                                    ,ResourceName,ResourceType);
                   end;
                 finally
                   BinFileStream.Free;
                   BinMemStream.Free;
                 end;
             except
               Application.MessageBox(PCHAR(Appli_Message[6]+BinFilename+''''),PCHAR(Appli_Message[1]),0);
               exit;
             end;
           end;
           ResMemStream.Position:=0;
           try
             FileTemp:=TStringList.Create;
             try
               FileTemp.LoadFromStream(ResMemStream);
               for a:=0 to FileTemp.Count-1 do
                   FMain.InTextLRS.Add(FileTemp.Strings[a]);

             finally
               FileTemp.Free;
             end;
           except
             Application.MessageBox(PCHAR(Appli_Message[7]),PCHAR(Appli_Message[1]),0);
           end;
       finally
         ResMemStream.Free;

       end;
       FMain.DisableView;
       FMain.LoadLRS;
     end;
end;

//******************************************************************************
procedure TFMain.MenuListDeleteClick(Sender: TObject);
var tree : TTreeNode;
    texte,RessourceName : string;
    i : integer;
begin
  tree:=FMain.TreeView1.Selected;
  texte:=tree.Text;
  if Application.MessageBox(PCHAR(Appli_Message[8]+texte+'?'),PCHAR(Appli_Message[3]),MB_YESNO)=IDYES then
     begin
       texte:=tree.Text;
       i:=pos('(',texte);
       RessourceName:=copy(texte,1,i-1);
       FMain.deleteRessource(RessourceName);
       FMain.DisableView;
       FMain.LoadLRS;
     end;
end;

//******************************************************************************
procedure TFMain.MenuOpenClick(Sender: TObject);
begin
  if FMain.FileChange then
    begin
      if Application.MessageBox(PCHAR(Appli_Message[2]),PCHAR(Appli_Message[3]),MB_YESNO)=IDYES then
         FMain.MenuSaveClick(nil);
    end;
  if FMain.OpenDialogLRS.Execute then
     begin
       InTextLRS.LoadFromFile(FMain.OpenDialogLRS.FileName);
       FMain.LoadLRS;
       FMain.DisableView;
       FMain.FileChange:=False;
     end;
end;

procedure TFMain.MenuRusClick(Sender: TObject);
begin
  FMain.MenuFile.Caption:='Файл';
  FMain.MenuOpen.Caption:='Открыть';
  FMain.MenuSave.Caption:='Сохранить';
  FMain.MenuLangage.Caption:='Язык';
  FMain.MenuExit.Caption:='Выход';
  FMain.MenuListAdd.Caption:='Добавить';
  FMain.MenuListDelete.Caption:='Удалить';
  FMain.OpenDialogLRS.Title:='Открыть LRS-файл';
  FMain.OpenDialogFile.Title:='Открыть файл';
  FMain.SaveDialogRessource.Title:='Сохранить текущий оресурс в lrs-файл';
  FMain.SaveDialogLRS.Title:='Сохранить текущий LRS-ресурс';
  FMain.GroupBox1.Caption:='Список ресурсов';
  FMain.GroupBox2.Caption:='Просмотр ресурса';
  Appli_Message[0]:='Не возможно преобразовать Delphi-форму в текстовое представление: ';
  Appli_Message[1]:='Ошибка';
  Appli_Message[2]:='Ваш lrs-файл изменён! Желаете сохранить его?';
  Appli_Message[3]:='Внимание';
  Appli_Message[4]:='Невозможно открыть файл ''';
  Appli_Message[5]:='Нет имени ресурса';
  Appli_Message[6]:='Невозможно прочесть файл ''';
  Appli_Message[7]:='Невозможно открыть временный файл';
  Appli_Message[8]:='Вы уверены, что хотите удалить ресурс :';
end;

//******************************************************************************
procedure TFMain.MenuSaveClick(Sender: TObject);
var texte : string;
begin
  if FMain.SaveDialogLRS.Execute then
    begin
      texte:=ExtractFileExt(FMain.SaveDialogLRS.FileName);
      if lowercase(texte)<>'.lrs' then FMain.SaveDialogLRS.FileName:=FMain.SaveDialogLRS.FileName+'.lrs';
      FMain.InTextLRS.SaveToFile(FMain.SaveDialogLRS.FileName);
      FMain.FileChange:=False;
    end;
end;

//******************************************************************************
procedure TFMain.ToolNewFileClick(Sender: TObject);
begin
  if FMain.FileChange then
    begin
      if Application.MessageBox(PCHAR(Appli_Message[2]),PCHAR(Appli_Message[3]),MB_YESNO)=IDYES then
         FMain.MenuSaveClick(nil);
    end;
  InTextLRS.Clear;
  FMain.TreeView1.Items.Clear;
  FMain.DisableView;
  FMain.FileChange:=False;
end;

//******************************************************************************
procedure TFMain.ToolSaveRessourceClick(Sender: TObject);
var tree : TTreeNode;
    texte,RessourceName,RessourceType : string;
    i : integer;
    ImageId : integer;
begin
  tree:=FMain.TreeView1.Selected;
  if tree=nil then exit;
  texte:=tree.Text;
  i:=pos('(',texte);
  RessourceName:=copy(texte,1,i-1);
  delete(texte,1,i);
  i:=pos(')',texte);
  RessourceType:=copy(texte,1,i-1);
  ImageId:=tree.ImageIndex;
  if ImageId=0 then
    begin
      FMain.SaveDialogRessource.Filter:=RessourceType+' Image|'+'*.'+Ressourcetype;
    end else
  if ImageId=2 then
    begin
      FMain.SaveDialogRessource.Filter:=RessourceType+' Image|'+'*.'+Ressourcetype;
    end else
    begin
      FMain.SaveDialogRessource.Filter:=RessourceType+' Unknow|'+'*.'+Ressourcetype;
    end;
   FMain.SaveDialogRessource.FileName:=RessourceName+'.'+RessourceType;
   FMain.SaveDialogRessource.DefaultExt:=RessourceType;
   if FMain.SaveDialogRessource.Execute then
     begin
       texte:=ExtractFileExt(FMain.SaveDialogRessource.FileName);
       if length(texte)=0 then
          FMain.SaveDialogRessource.FileName:=FMain.SaveDialogRessource.FileName
                                              +'.'+Ressourcetype;
       if FMain.Image1.Visible then
         begin
           FMain.Image1.Picture.SaveToFile(FMain.SaveDialogRessource.FileName);
         end else
       if FMain.Memo1.Visible then
         begin
           FMain.Memo1.Lines.SaveToFile(FMain.SaveDialogRessource.FileName);
         end;
     end;
end;

//******************************************************************************
procedure TFMain.TreeView1Click(Sender: TObject);
var tree : TTreeNode;
    texte,RessourceName,RessourceType : string;
    i : integer;
    ImageId : integer;
begin
  tree:=FMain.TreeView1.Selected;
  texte:=tree.Text;
  i:=pos('(',texte);
  RessourceName:=copy(texte,1,i-1);
  delete(texte,1,i);
  i:=pos(')',texte);
  RessourceType:=copy(texte,1,i-1);
  ImageId:=tree.ImageIndex;
  if ImageId=0 then FMain.ViewUnknow(RessourceName)
  else if ImageId=2 then FMain.ViewPicture(RessourceName,RessourceType)
  else FMain.ViewUnknow(RessourceName);
end;

//******************************************************************************
procedure TFMain.LoadLRS;
var i,j: integer;
    texte,NameRessource,TypeRessource : string;
    tree : TTreeNode;
begin
  FMain.TreeView1.Items.Clear;
  for i:=0 to FMain.InTextLRS.Count-1 do
    begin
      texte:=InTextLRS.Strings[i];
      j:=pos('LazarusResources.Add(',texte);
      if j>0 then
         begin
           delete(texte,1,j+21);
           j:=pos('''',texte);
           NameRessource:=copy(texte,1,j-1);
           delete(texte,1,j);
           j:=pos('''',texte);
           delete(texte,1,j);
           j:=pos('''',texte);
           TypeRessource:=copy(texte,1,j-1);
           tree:=FMain.TreeView1.Items.Add(nil,NameRessource+'('+TypeRessource+')');
           texte:=uppercase(TypeRessource);
           if (texte='XPM')
              or (texte='BMP')
              or(texte='JPG')
              or(texte='JPEG')
              or(texte='BMP')
              or (texte='ICO')
              or (texte='PNG')
              or(texte='ICON') then
              begin
                tree.ImageIndex:=2;
              end else
           if (texte='FORMDATA') then
              begin
                tree.ImageIndex:=0;
              end else tree.ImageIndex:=1;

         end;
    end;
end;

//******************************************************************************
procedure TFMain.ViewPicture(ResName,extension : string);
var headerindex : integer;
    Memory : TMemoryStream;
begin
  FMain.DisableView;
  headerindex:=FindResourceInLRS(ResName,InTextLRS);
  try
    Memory:=TMemoryStream.Create;
    Memory:=ExtractResource(HeaderIndex,InTextLRS);
    try
      FMain.Image1.Visible:=true;
      Memory.Position:=0;
      FMain.Image1.Picture.LoadFromStreamWithFileExt(Memory,extension);
    except
      FMain.Image1.Visible:=False;
    end;
  finally
    FMain.RessourceChange:=False;
    Memory.Free;

  end;
end;

//******************************************************************************
procedure TFMain.ViewUnknow(ResName : string);
var i,j,k : integer;
    texte,ResName2 : string;
begin
  FMain.DisableView;
  FMain.Memo1.Clear;
  j:=-1;
  i:=0;
  ResName2:='LazarusResources.Add('''+ResName;
  while (j<0) and (i<FMain.InTextLRS.Count) do
    begin
      texte:=FMain.InTextLRS.Strings[i];
      k:=pos(ResName2,texte);
      if k>0 then j:=i;
      i:=i+1;
    end;
  if j<>-1 then
    begin
      i:=j;
      j:=-1;
      while (j<0) and (i<FMain.InTextLRS.Count) do
        begin
          texte:=FMain.InTextLRS.Strings[i];
          k:=pos(']);',texte);
          if k>0 then j:=i;
          FMain.Memo1.Lines.Add(texte);
          i:=i+1;
        end;
    end;
  if FMain.Memo1.Lines.Count>0 then FMain.Memo1.Visible:=True;
  FMain.RessourceChange:=False;
end;

//******************************************************************************
procedure TFMain.DisableView;
begin
  FMain.Memo1.Visible:=false;
  FMain.Image1.Visible:=False;
end;

//******************************************************************************
procedure TFMain.deleteRessource(ResName: string);
var i,j,k : integer;
    texte,ResName2 : string;
begin
  ResName2:='LazarusResources.Add('''+ResName;
  i:=0;
  j:=-1;
  while (j<0) and (i<FMain.InTextLRS.Count) do
    begin
      texte:=FMain.InTextLRS.Strings[i];
      k:=pos(ResName2,texte);
      if k>0 then j:=i;
      i:=i+1;
    end;
  if j>-1 then
    begin
      texte:=FMain.InTextLRS.Strings[j];
      While (pos(']);',texte)<=0) do
        begin
          FMain.InTextLRS.Delete(j);
          texte:=FMain.InTextLRS.Strings[j];
        end;
      if (pos(']);',texte)>0)then FMain.InTextLRS.Delete(j);
    end;
end;

end.

