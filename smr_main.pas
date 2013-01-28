unit smr_main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, smr_base,
  smr_selector, SynEdit, SynHighlighterPas, StdCtrls, ExtCtrls, ComCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
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
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  SmbHook: THook;
  Select: TMWindowSelector;

implementation
  uses smr_utils;
{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  SmbHook:=THook.Create;
  Select:=TMWindowSelector.Create;
  Self.Caption:='Macros recorder for Simba v 0.1 for'+{$IFDEF Windows}'[WIN]'{$ELSE}'[LIN]'{$ENDIF};
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin

end;

procedure TForm1.ToolButton3Click(Sender: TObject);
begin

end;

procedure TForm1.ToolButton3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SmbHook.WinCaption:=GetWindowCaption(Select.Drag);
end;


procedure TForm1.Button1Click(Sender: TObject);
begin
  SmbHook.StartCatch
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  st: TStringList;
begin
  SmbHook.StopCatch;
  st:=TStringList.Create;
  smbHook.Delete(smbHook.Count-1);
  smbHook.Delete(smbHook.Count-1);
  SmbHook.GenerateScript(st,0);
  SynEdit1.Text:=st.Text;
end;

end.

