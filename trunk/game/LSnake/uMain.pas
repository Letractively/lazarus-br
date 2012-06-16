unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Spin, uSnake;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1 : TButton;
    CheckBox1 : TCheckBox;
    Label1 : TLabel;
    PaintBox1 : TPaintBox;
    LabelPontos : TLabel;
    SpinEdit1 : TSpinEdit;
    procedure Button1Click(Sender : TObject);
    procedure CheckBox1Change(Sender : TObject);
    procedure FormKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
    procedure PaintBox1Paint(Sender : TObject);
    procedure PaintBox1Resize(Sender : TObject);
    procedure SpinEdit1Change(Sender : TObject);
  private
    FSnake : TSnake;
    FImgElipse : TRasterImage;
    FImgPeca : TRasterImage;
    procedure SnakeMoved(Sender : TObject);
    procedure SnakeFim(Sender : TObject);
    procedure SnakePontos(Sender : TObject);
  public
    { public declarations }
    constructor Create(TheOwner : TComponent); override;
    destructor Destroy; override;
  end;

var
  Form1 : TForm1;

implementation

uses LCLType;

{$R *.lfm}

const
  SIZE_ELO = 10;

{ TForm1 }

procedure TForm1.FormKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
begin
  if not FSnake.GetRuning then Exit;

  case Key of
    VK_UP   : FSnake.SetDirecao(TDirections.UP);
  	VK_DOWN : FSnake.SetDirecao(TDirections.DOWN);
  	VK_LEFT : FSnake.SetDirecao(TDirections.LEFT);
  	VK_RIGHT: FSnake.SetDirecao(TDirections.RIGHT);
    else Exit;
  end;
  Key := 0;
end;

//function DbgS(const p: TPoint): string;
//begin
//  Result := '('+IntToHex(p.x,2)+','+IntToHex(p.y,2)+')';
//end;

{$R Imgens.rc}

procedure TForm1.PaintBox1Paint(Sender : TObject);
var
  i : Integer;
  g : TCanvas;
begin
  g := PaintBox1.Canvas;
  g.Brush.Color := clBlack;
  g.FillRect(Rect(0,0,PaintBox1.Width, PaintBox1.Height));
  //g.Pen.Color := clBlue;
  //g.Brush.Color := clBlue;

  for i := 0 to FSnake.GetSize -1 do
    with FSnake.GetPosAt(i) do
    	//g.Ellipse(Bounds(x * SIZE_ELO, y * SIZE_ELO, SIZE_ELO, SIZE_ELO));
    	g.Draw(x * SIZE_ELO, y * SIZE_ELO, FImgElipse);

  with FSnake.GetPosPeca do
    if (x > -1) and (y > -1) then
    begin
      //g.Brush.Color := clRed;
      //g.Pen.Color := clRed;
      //g.Ellipse(Bounds(x * SIZE_ELO, y * SIZE_ELO, SIZE_ELO, SIZE_ELO));
    	g.Draw(x * SIZE_ELO, y * SIZE_ELO, FImgPeca);
    end;

  with FSnake.GetPosBonus do
    if (x > -1) and (y > -1) then
    begin
      g.Brush.Color := clGreen;
      g.FillRect(Bounds(x * SIZE_ELO, y * SIZE_ELO, SIZE_ELO, SIZE_ELO));
    end;
end;

procedure TForm1.PaintBox1Resize(Sender : TObject);
begin
  FSnake.WPanel := PaintBox1.Width div SIZE_ELO;
  FSnake.HPanel := PaintBox1.Height div SIZE_ELO;
end;

procedure TForm1.SpinEdit1Change(Sender : TObject);
begin
  FSnake.SetSeed(SpinEdit1.Value);
end;

procedure TForm1.SnakeMoved(Sender : TObject);
begin
  PaintBox1.Invalidate;
end;

procedure TForm1.SnakeFim(Sender : TObject);
begin
  //Button1.Enabled := True;
  if FSnake.Erro <> -1 then
    if MessageDlg('Fim'+sLineBreak
              +'Erro: '+IntToStr(FSnake.Erro)+' '
              +'Pontos: '+IntToStr(FSnake.Pontos)+sLineBreak+sLineBreak
              +'Novo jogo?',mtInformation,mbYesNo,0) = mrYes then
    begin
      Button1Click(Sender);
    end;
end;

procedure TForm1.SnakePontos(Sender : TObject);
begin
  LabelPontos.Caption := 'Pontos: '+IntToStr(FSnake.Pontos);
end;

constructor TForm1.Create(TheOwner : TComponent);
begin
  inherited Create(TheOwner);
  FImgElipse := TBitmap.Create;
  FImgPeca := TBitmap.Create;
  FSnake := TSnake.Create;
  DoubleBuffered := True;
  FImgElipse.LoadFromResourceName(HINSTANCE, 'BMP_ELIPSE');

  //FImgPeca.Canvas.Brush.Color := clRed;
  //FImgPeca.Canvas.FillRect(0, 0, FImgPeca.Width, FImgPeca.Height);
  //FImgPeca.RawImage.ExtractRect(FImgElipse);
  FImgPeca.LoadFromResourceName(HINSTANCE, 'BMP_ELIPSE2');
  Caption := Application.Title;
end;

destructor TForm1.Destroy;
begin
  FreeAndNil(FImgElipse);
  FreeAndNil(FImgPeca);
  FreeAndNil(FSnake);
  inherited Destroy;
end;

procedure TForm1.Button1Click(Sender : TObject);
begin
  if FSnake.GetRuning then
  begin
    FSnake.Stop;
    Button1.Caption := 'Novo';
  end else
  begin
    FSnake.New(SpinEdit1.Value, @SnakePontos, @SnakeFim, @SnakeMoved);
    CheckBox1.Checked := False;
    Button1.Caption := 'Parar';
  end;
end;

procedure TForm1.CheckBox1Change(Sender : TObject);
begin
  FSnake.Paused := CheckBox1.Checked;
end;

end.

