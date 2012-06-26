program project1;

{$mode objfpc}{$H+}

uses
  Classes,
  FPimage,
  FPImgCanv,
  ftfont,
  FPWritePNG,
  FPCanvas;

  procedure Test;
  var
    img: TFPMemoryImage;
    wr: TFPWriterPNG;
    ms: TMemoryStream;
    imgCanvas: TFPImageCanvas;
    fs: TFileStream;
    ft: TFreeTypeFont;
  begin
    img := nil;
    imgCanvas := nil;
    wr := nil;
    ms := nil;
    fs := nil;
    ft := nil;
    try
      // initialize free type font manager
      ftfont.InitEngine;
      FontMgr.SearchPath := 'C:\Windows\Fonts\';
      ft := TFreeTypeFont.Create;

      // create an image of width 200, height 100
      img := TFPMemoryImage.Create(200, 100);
      img.UsePalette := False;
      // create the canvas with the drawing operations
      imgCanvas := TFPImageCanvas.Create(img);

      // paint white background
      imgCanvas.Brush.FPColor := colWhite;
      imgCanvas.Brush.Style := bsSolid;
      imgCanvas.Rectangle(0, 0, img.Width, img.Height);

      // paint text
      imgCanvas.Font := ft;
      imgCanvas.Font.Name := 'Arial';
      imgCanvas.Font.Size := 20;
      imgCanvas.TextOut(10, 30, 'Test');

      // write image as png to memory stream
      wr := TFPWriterPNG.Create;
      ms := TMemoryStream.Create;
      wr.ImageWrite(ms, img);
      // write memory stream to file
      ms.Position := 0;
      fs := TFileStream.Create('testfont.png', fmCreate);
      fs.CopyFrom(ms, ms.Size);
    finally
      ft.Free;
      ms.Free;
      wr.Free;
      imgCanvas.Free;
      img.Free;
      fs.Free;
    end;
  end;

begin
  Test;
end.

