unit Main;

interface //#################################################################### ■

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.Objects, FMX.ScrollBox, FMX.StdCtrls,
  LUX.Vision.OpenCV, LUX.Vision.OpenCV.Capture, LUX.Vision.OpenCV.Detect;

type
  TForm1 = class(TForm)
    Image1: TImage;
    ScrollBar1: TScrollBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
  private
    { private 宣言 }
  public
    { public 宣言 }
    _Video :TocvVideo;
    _Detect :THaarCascade;
    _Image :TocvBitmap4;
    ///// メソッド
    procedure ShowFrame;
  end;

var
  Form1: TForm1;

implementation //############################################################### ■

{$R *.fmx}

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

/////////////////////////////////////////////////////////////////////// メソッド

procedure TForm1.ShowFrame;
var
   I :Integer;
begin
     _Video.Frame.CopyTo( _Image );

     with Image1 do
     begin
          _Image.CopyTo( Bitmap );

          with Bitmap.Canvas do
          begin
               BeginScene;

               with Stroke do
               begin
                    Color     := TAlphaColorRec.Red;
                    Thickness := 2;
               end;

               with _Detect do
               begin
                    for I := 0 to FaceN-1 do DrawEllipse( TRectF.Create( Box[ I ] ), 1 );
               end;

               EndScene;
          end;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
begin
     _Video := TocvVideo.Create( '..\..\_DATA\Movie.mp4' );

     _Detect := THaarCascade.Create( '..\..\_DATA\Cascade\Haar\haarcascade_frontalface_default.xml' );

     with _Video do
     begin
          _Image := TocvBitmap4.Create( FrameWidth, FrameHeight );

          Image1.Bitmap.SetSize( FrameWidth, FrameHeight );

          ScrollBar1.Max := FrameCount - 1;
     end;

     //////////

     _Video.QueryFrame;

     _Detect.Search( _Video.Frame );

     ShowFrame;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
     _Detect.Free;

     _Image.Free;

     _Video.Free;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TForm1.ScrollBar1Change(Sender: TObject);
begin
     _Video.PosFrames := Round( ScrollBar1.Value );

     //////////

     _Video.QueryFrame;

     _Detect.Search( _Video.Frame );

     ShowFrame;
end;

end. //######################################################################### ■
