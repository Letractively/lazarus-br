unit fPerson;

{$mode objfpc}{$H+}

interface

uses
  Forms, Controls, StdCtrls, ExtCtrls, FPJSON;

type

  { TfrmPerson }

  TfrmPerson = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    edtName: TEdit;
    lblName: TLabel;
    bottom: TPanel;
    client: TPanel;
  public
    class function Execute(json: TJSONObject): Boolean;
  end;

implementation

{$R *.lfm}

{ TfrmPerson }

class function TfrmPerson.Execute(json: TJSONObject): Boolean;
begin
  with Self.Create(nil) do
    try
      edtName.Text := json['name'].AsString;
      Result := ShowModal = mrOk;
      if Result then
        json['name'].AsString := edtName.Text
      else
        json.Free;
    finally
      Free;
    end;
end;

end.

