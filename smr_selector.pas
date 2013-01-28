unit smr_selector;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Forms,controls,graphics,extctrls,windows;
type

    { TMWindowSelector }

    TMWindowSelector = class(TObject)
          constructor Create();
          destructor Destroy; override;
          function Drag: HWND;
    public
          LastPick: HWND;
          haspicked: boolean;
    end;

implementation

{ TMWindowSelector }

constructor TMWindowSelector.Create;
begin
  inherited create;
  haspicked:= false;
end;

destructor TMWindowSelector.Destroy;
begin
  inherited Destroy;
end;

function TMWindowSelector.Drag: HWND;
var
  TargetRect: TRect;
  Region : HRGN;
  Cursor : TCursor;
  TempHandle : Hwnd;
  Handle : Hwnd;
  DragForm : TForm;
  EdgeForm : TForm;
  Style : DWord;
  W,H: integer;
const
  EdgeSize =4;
  WindowCol = clred;
begin;
  Cursor:= Screen.Cursor;
  Screen.Cursor:= crCross;
  TempHandle := GetDesktopWindow;
  EdgeForm := TForm.Create(nil);
  EdgeForm.Color:= WindowCol;
  EdgeForm.BorderStyle:= bsNone;
  EdgeForm.Show;

  DragForm := TForm.Create(nil);
  DragForm.Color:= WindowCol;
  DragForm.BorderStyle:= bsNone;
  DragForm.Show;

  Style := GetWindowLong(DragForm.Handle, GWL_EXSTYLE);
  SetWindowLong(DragForm.Handle, GWL_EXSTYLE, Style or WS_EX_LAYERED or WS_EX_TRANSPARENT);
  SetLayeredWindowAttributes(DragForm.Handle, 0, 100, LWA_ALPHA);

  while GetAsyncKeyState(VK_LBUTTON) <> 0 do
  begin;
    Handle:= WindowFromPoint(Mouse.CursorPos);
    if (Handle <> TempHandle) and (Handle <> EdgeForm.Handle) then
    begin;
      GetWindowRect(Handle, TargetRect);
      W :=TargetRect.Right - TargetRect.Left+1;
      H :=TargetRect.Bottom - TargetRect.Top+1;
      DragForm.SetBounds(TargetRect.Left,TargetRect.top,W,H);//Draw the transparent form

      SetWindowRgn(EdgeForm.Handle,0,false);//Delete the old region
      Region := CreateRectRgn(0,0,w-1,h-1); //Create a full region, of the whole form
      CombineRgn(Region,Region,CreateRectRgn(EdgeSize,EdgeSize,w-1-(edgesize),h-1-(edgesize)),RGN_XOR); //Combine a the 2 regions (of the full form and one without the edges)
      SetWindowRgn(edgeform.Handle,Region,true);//Set the only-edge-region!
      EdgeForm.SetBounds(TargetRect.Left,TargetRect.top,W,H);//Move the form etc..
      TempHandle  := Handle;
    end;
    Application.ProcessMessages;
    Sleep(30);
  end;
  Result := TempHandle;
  LastPick:= TempHandle;
  haspicked:= true;
  Screen.Cursor:= cursor;
  DragForm.Hide;
  DragForm.Free;
  EdgeForm.Hide;
  EdgeForm.Free;
end;

end.

