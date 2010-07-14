unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, StdCtrls, ExtCtrls;

type

  { TMainForm }

  TMainForm = class(TForm)
    Button1: TButton;
    Form2Button: TButton;
    Form1Button: TButton;
    MainNotebook: TNotebook;
    BottomPanel: TPanel;
    procedure Form1ButtonClick(Sender: TObject);
    procedure Form2ButtonClick(Sender: TObject);
    procedure MainNotebookCloseTabClicked(Sender: TObject);
  public
    procedure CreatePageForm(const AFormClass: TFormClass;
      var ANotebook: TNotebook; const ACaption: TCaption = '';
      const AIndex: Integer = 0);
    function PageFormExists(const APageName: TComponentName;
      var ANotebook: TNotebook): Boolean;
    procedure ClosePageForm(const APageName: TComponentName;
      var ANotebook: TNotebook);
  end;

var
  MainForm: TMainForm;

implementation

uses
  Unit1, Unit2;

{ TMainForm }

procedure TMainForm.Form1ButtonClick(Sender: TObject);
begin
  CreatePageForm(TForm1, MainNotebook);
end;

procedure TMainForm.Form2ButtonClick(Sender: TObject);
begin
  CreatePageForm(TForm2, MainNotebook);
end;

procedure TMainForm.MainNotebookCloseTabClicked(Sender: TObject);
begin
  ClosePageForm(TPage(Sender).Caption, MainNotebook);
end;

procedure TMainForm.CreatePageForm(const AFormClass: TFormClass;
  var ANotebook: TNotebook; const ACaption: TCaption = ''; const AIndex: Integer = 0);
var
  VPage: TPage;
  VForm: TForm;
begin
  VPage := TPage.Create(ANotebook);
  VForm := AFormClass.Create(VPage);
  if not PageFormExists(VForm.Caption, ANotebook) then
  begin
    if ACaption = EmptyStr then
      VPage.Caption := VForm.Caption
    else
      VPage.Caption := ACaption;
    VPage.Parent := ANotebook;
    VPage.ImageIndex := AIndex;
    VForm.Align := alClient;
    VForm.BorderStyle := bsNone;
    VForm.Parent := VPage;
    VForm.Show;
    ANotebook.PageIndex := VPage.PageIndex;
  end
  else
  begin
    VForm.Free;
    VPage.Free;
  end;
end;

function TMainForm.PageFormExists(const APageName: TComponentName;
  var ANotebook: TNotebook): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to Pred(ANotebook.PageCount) do
  begin
    if ANotebook.Page[I].Caption = APageName then
    begin
      Result := True;
      ANotebook.ActivePage := APageName;
      Break;
    end;
  end;
end;

procedure TMainForm.ClosePageForm(const APageName: TComponentName;
  var ANotebook: TNotebook);
var
  I: Integer;
begin
  for I := 0 to Pred(ANotebook.PageCount) do
  begin
    if ANotebook.Page[I].Caption = APageName then
    begin
      ANotebook.Page[I].Free;
      Break;
    end;
  end;
end;

initialization
  {$I MainFrm.lrs}

end.

