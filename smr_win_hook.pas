unit smr_win_hook;

{$ifdef fpc}
 {$mode Delphi}
{$endif}

interface

uses
  Classes, SysUtils, Windows,smr_types,smr_utils;

type
  //KeyBoard hook struct
  PKbdDllHookStruct = ^TKbdDllHookStruct;
  _KBDLLHOOKSTRUCT = record
    vkCode: DWORD;
    scanCode: DWORD;
    flags: DWORD;
    time: DWORD;
    dwExtraInfo: PDWORD;
  end;
  TKbdDllHookStruct = _KBDLLHOOKSTRUCT;
  //Mouse hook struct
  tagMSLLHOOKSTRUCT = packed record
    pt : TPoint;
    mouseData : DWord;
    flags : DWord;
    time : DWord;
    dwExtraInfo : PDWord;
  end;
  tMSLLHOOKSTRUCT = tagMSLLHOOKSTRUCT;
  PMSLLHOOKSTRUCT = ^TMSLLHOOKSTRUCT;
  { TBaseRecorder }


  TBaseRecorder = class(THookItemList)
     public
       Active: boolean;
       AppPid: integer;
       WinCaption: string;
       procedure StartCatch();
       procedure StopCatch();
     end;
  procedure Sethook();
  procedure Removehook();
  function LowLevelKeyboardProc(nCode: LongInt; wParam: wParam; lParam: lParam): Longint; Stdcall;
  function LowLevelMouseProc(nCode: LongInt; wParam: WPARAM; LParam: LPARAM): Longint; stdcall;
 var
 LastClick,ClickInterval,KeyPressTime: LongWord;
 kHook,mHook: THandle;
 Hooks: THookItemList;
 mPT: TPoint;
implementation

function GetCharFromVirtualKey(Key: Word): string;
 var
    keyboardState: TKeyboardState;
    asciiResult: Integer;
 begin
    GetKeyboardState(keyboardState) ;

    SetLength(Result, 2) ;
    asciiResult := ToAscii(key, MapVirtualKey(key, 0), keyboardState, @Result[1], 0) ;
    case asciiResult of
      0: Result := '';
      1: SetLength(Result, 1) ;
      2:;
      else
        Result := '';
    end;
 end;
procedure Sethook;
const
  WH_KEYBOARD_LL = 13;
  WH_MOUSE_LL = 14;
begin
  Hooks:=THookItemList.Create;
  kHook := SetWindowsHookEx(WH_KEYBOARD_LL,LowLevelKeyboardProc, hInstance, 0);
  mHook:=SetWindowsHookEx(WH_MOUSE_LL,LowLevelMouseProc, HInstance, 0);
  if (kHook = 0) or (mHook = 0) then RaiseLastOSError;
end;

procedure Removehook;
begin
 // Hooks.Free;
  UnhookWindowsHookEx(kHook);
  UnhookWindowsHookEx(mHook);
end;

function LowLevelKeyboardProc(nCode: LongInt; wParam: wParam;
  lParam: lParam): Longint; Stdcall;
const
  RPT_WPARAM_DATA = '%s';
  RPT_LPARAM_DATA = '%d';
var
 oHookItem: THookItem;
 iVKey:integer;
 sVKey:string;
 StrResult: String;
 Time,SubTime,PressedTime,Res: integer;
begin
  Time:=0;SubTime:=0;PressedTime:=0;
  if nCode = HC_ACTION then
    Result := CallNextHookEx(kHook, nCode, WParam, LParam);
  case WParam of
    WM_KEYDOWN: begin StrResult := Format(RPT_WPARAM_DATA, ['']); SubTime:=GetTickCount; end;
    WM_SYSKEYDOWN: begin StrResult := Format(RPT_WPARAM_DATA, ['']); SubTime:=GetTickCount; end;
  end;
  StrResult := Format(RPT_LPARAM_DATA, [PKbdDllHookStruct(LParam)^.vkCode]);
  if (Wparam=WM_KEYUP) or (Wparam=WM_SYSKEYUP) then
   begin
    StrResult:='';
    Time:=GetTickCount;
    PressedTime:=SubTime-Time;
   end;
   sVKey:=StrResult;
  if StrResult<>'' then
   iVKey:=StrToInt(StrResult) //Получаем iVKey нажатой клавиши
  else iVKey:=0;
  if not eq(SVKey,'') and (iVKey<>0) then
    begin
      oHookItem:=Hooks.AddItem;
      oHookItem.ItemType:=false;
      oHookItem.KeyCode:=iVKey;
      oHookItem.VirtualKey:=GetCharFromVirtualKey(iVKey);
      oHookItem.PressedTime:=PressedTime;
    end;
end;

function LowLevelMouseProc(nCode: LongInt; wParam: WPARAM;
  LParam: LPARAM): Longint; stdcall;
var
 MS:PMSLLHOOKSTRUCT;
 oHookItem: THookItem;
 Time,SubTime,PressedTime: integer;
begin
  Result := CallNextHookEx(mHook, nCode, WParam, LParam);
  Time:=0;SubTime:=0;
  SubTime:=GetTickCount;
  if wParam = WM_MOUSEMOVE then //когда мышь побежала-побежала...
   begin
    MS:=PMSLLHOOKSTRUCT(lParam);
    mPt.x:=MS^.pt.X;
    mPt.y:=MS^.pt.Y;
   end;
   MS:=PMSLLHOOKSTRUCT(lParam);
   mPt.x:=MS^.pt.X;
   mPt.y:=MS^.pt.Y;
  case WParam of
   WM_LBUTTONDOWN:
     begin
       time:=GetTickCount;
       Pressedtime:=time-SubTime;
       oHookItem:=Hooks.AddItem;
       oHookItem.ItemType:=true;
       oHookItem.ClickType:=0;
       oHookItem.ClickCoord:=mPt;
       oHookItem.WaitingTime:=PressedTime;
     end;
   WM_LBUTTONUP:
     begin
       time:=GetTickCount;
       Pressedtime:=time-SubTime;
       oHookItem:=Hooks.AddItem;
       oHookItem.ItemType:=true;
       oHookItem.ClickType:=1;
       oHookItem.ClickCoord:=mPt;
       oHookItem.WaitingTime:=PressedTime;
     end;
   WM_LBUTTONDBLCLK:
     begin
       time:=GetTickCount;
       Pressedtime:=time-SubTime;
       oHookItem:=Hooks.AddItem;
       oHookItem.ItemType:=true;
       oHookItem.ClickType:=2;
       oHookItem.ClickCoord:=mPt;
       oHookItem.WaitingTime:=PressedTime;
     end;
   WM_RBUTTONDOWN:
     begin
       time:=GetTickCount;
       Pressedtime:=time-SubTime;
       oHookItem:=Hooks.AddItem;
       oHookItem.ItemType:=true;
       oHookItem.ClickType:=3;
       oHookItem.ClickCoord:=mPt;
       oHookItem.WaitingTime:=PressedTime;
     end;
   WM_RBUTTONUP:
     begin
       time:=GetTickCount;
       Pressedtime:=time-SubTime;
       oHookItem:=Hooks.AddItem;
       oHookItem.ItemType:=true;
       oHookItem.ClickType:=4;
       oHookItem.ClickCoord:=mPt;
       oHookItem.WaitingTime:=PressedTime;
     end;
   WM_MBUTTONDOWN:
     begin
       time:=GetTickCount;
       Pressedtime:=time-SubTime;
       oHookItem:=Hooks.AddItem;
       oHookItem.ItemType:=true;
       oHookItem.ClickType:=5;
       oHookItem.ClickCoord:=mPt;
       oHookItem.WaitingTime:=PressedTime;
     end;
   WM_MBUTTONUP:
     begin
       time:=GetTickCount;
       Pressedtime:=time-SubTime;
       oHookItem:=Hooks.AddItem;
       oHookItem.ItemType:=true;
       oHookItem.ClickType:=6;
       oHookItem.ClickCoord:=mPt;
       oHookItem.WaitingTime:=PressedTime;
     end;
  { WM_MOUSEWHEEL: Form1.Memo1.Lines.Add('Мыша тащиться.');}
  end;
end;

procedure TBaseRecorder.StartCatch;
begin
  SetHook;
end;

procedure TBaseRecorder.StopCatch;
var
 i: integer;
 oHookItem: THookItem;
begin
  for i:=0 to Hooks.Count-1 do
   begin
     oHookItem:=Self.AddItem;
     if not Hooks.Items[i].ItemType then
         begin
           oHookItem.ItemType:=Hooks.Items[i].ItemType;
           oHookItem.VirtualKey:=Hooks.Items[i].VirtualKey;
           oHookItem.KeyCode:=Hooks.Items[i].KeyCode;
           oHookItem.PressedTime:=Hooks.Items[i].PressedTime;
         end
          else
         begin
           oHookItem.ItemType:=Hooks.Items[i].ItemType;
           oHookItem.ClickCoord:=Hooks.Items[i].ClickCoord;
           oHookItem.ClickType:=Hooks.Items[i].ClickType;
           oHookItem.WaitingTime:=Hooks.Items[i].WaitingTime;
         end;
   end;
  RemoveHook;
end;

end.

