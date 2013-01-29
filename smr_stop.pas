unit smr_stop;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, GR32_Image, Forms, Controls, Graphics, Dialogs;

type

  { TStopForm }

  TStopForm = class(TForm)
    Image32_1: TImage32;
    procedure FormShow(Sender: TObject);
    procedure Image32_1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  StopForm: TStopForm;

implementation
uses smr_main{$ifdef Windows},Windows{$endif};

{ TStopForm }

procedure TStopForm.Image32_1Click(Sender: TObject);
begin
  Recorder.StopRecording;
end;

procedure TStopForm.FormShow(Sender: TObject);
begin
  Self.Left:=0;
  Self.Top:=0;
  SetWindowPos(Self.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
end;

{$R *.lfm}

end.

