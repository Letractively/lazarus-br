unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, ComCtrls, StdCtrls;

type

  { TMainForm }

  TMainForm = class(TForm)
    SplitButton: TButton;
    CombineButton: TButton;
    SplitFileProgressBar: TProgressBar;
    procedure CombineButtonClick(Sender: TObject);
    procedure SplitButtonClick(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ Split file / Dividir arquivo

Parametros:

AFileName: Especificar um arquivo para divisão.
ASizeOfFiles: Especificar o tamanho dos arquivos divididas (em bytes).
AProgressBar: Especificar a TProgressBar para mostrar o progresso da divisão.

Resultado:
SplitFile criará os arquivos FileName.001, FileName.002, FileName.003 e assim
por diante, e terão o tamanho em bytes definidos em ASizeOfFiles. }
procedure SplitFile(AFileName: TFileName; ASizeOfFiles: Int64;
  AProgressBar: TProgressBar);
var
  I: Word;
  VFileStream, VStream: TFileStream;
  VSplitFileName: string;
begin
  AProgressBar.Position := 0;
  VFileStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    for I := 1 to Trunc(VFileStream.Size / ASizeOfFiles) + 1 do
    begin
      VSplitFileName := ChangeFileExt(AFileName, '.' + FormatFloat('000', I));
      VStream := TFileStream.Create(VSplitFileName, fmCreate or fmShareExclusive);
      try
        if VFileStream.Size - VFileStream.Position < ASizeOfFiles then
          ASizeOfFiles := VFileStream.Size - VFileStream.Position;
        VStream.CopyFrom(VFileStream, ASizeOfFiles);
        AProgressBar.Position := Round((VFileStream.Position / VFileStream.Size) * 100);
      finally
        VStream.Free;
      end;
    end;
  finally
    VFileStream.Free;
  end;
end;

{ Combine files / Juntar arquivos

Parametros:

AFileName: Especificar o primeiro dos arquivos da divisão (.001).
ACombinedFileName: Especifique o nome combinado do arquivo (o arquivo a ser salvo).
ADeleteFileParts: Excluir arquivos .001, .002 etc.

Resultado:
CombineFiles criará um arquivo das divisões informadas. }
procedure CombineFiles(AFileName, ACombinedFileName: TFileName;
  ADeleteFileParts: Boolean);
var
  I: Word;
  VFileStream, VStream: TFileStream;
begin
  I := 1;
  VFileStream := TFileStream.Create(ACombinedFileName, fmCreate or fmShareExclusive);
  try
    while FileExists(AFileName) do
    begin
      VStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
      try
        VFileStream.CopyFrom(VStream, 0);
      finally
        VStream.Free;
        if ADeleteFileParts then
          DeleteFile(AFileName);
      end;
      Inc(I);
      AFileName := ChangeFileExt(AFileName, '.' + FormatFloat('000', I));
    end;
  finally
    VFileStream.Free;
  end;
end;

{ TMainForm }

procedure TMainForm.SplitButtonClick(Sender: TObject);
begin
  SplitFile(Application.ExeName, 1000000, SplitFileProgressBar);
end;

procedure TMainForm.CombineButtonClick(Sender: TObject);
begin
  CombineFiles(ChangeFileExt(Application.ExeName, '.001'), 'demo2.exe', True);
end;

end.

