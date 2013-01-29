unit smr_main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, smr_base,
  smr_selector,smr_stop, SynEdit, SynHighlighterPas, StdCtrls, ExtCtrls, ComCtrls;

type

  { TRecorder }

  TRecorder = class(TForm)
    ImageList1: TImageList;
    SynEdit1: TSynEdit;
    SynPasSyn1: TSynPasSyn;
    Timer1: TTimer;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ToolButton5Click(Sender: TObject);
  private
    { private declarations }
  public
    procedure StopRecording;
    { public declarations }
  end;

var
  Recorder: TRecorder;
  SmbHook: THook;
  Select: TMWindowSelector;

implementation
  uses smr_utils;
{$R *.lfm}

{ TRecorder }

procedure TRecorder.FormCreate(Sender: TObject);
begin
  SmbHook:=THook.Create;
  Select:=TMWindowSelector.Create;
  Self.Caption:='Macros recorder for Simba v 0.1 for'+{$IFDEF Windows}'[WIN]'{$ELSE}'[LIN]'{$ENDIF};
end;

procedure TRecorder.Timer1Timer(Sender: TObject);
begin

end;

procedure TRecorder.ToolButton1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TRecorder.ToolButton3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SmbHook.WinCaption:=GetWindowCaption(Select.Drag);
end;

procedure TRecorder.ToolButton5Click(Sender: TObject);
begin
   Self.Hide;
   SmbHook.StartCatch;
   StopForm.Show;
end;

procedure TRecorder.StopRecording;
var
  st: TStringList;
begin
  SmbHook.StopCatch;
  StopForm.Hide;
  Self.Show;
  st:=TStringList.Create;
  smbHook.Delete(smbHook.Count-1);
  sleep(100);
  smbHook.Delete(smbHook.Count-1);
  SmbHook.GenerateScript(st,0);
  SynEdit1.Text:=st.Text;
end;


procedure TRecorder.Button1Click(Sender: TObject);
begin

end;

procedure TRecorder.Button2Click(Sender: TObject);
begin

end;




end.

