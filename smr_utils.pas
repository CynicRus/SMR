unit smr_utils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Windows;

function Eq(aValue1, aValue2: string): boolean;

function GenSpaces(cnt: integer): string;

function GetWindowCaption(hWindow: HWND): string;

implementation

function GetWindowCaption(hWindow: HWND): string;
var
  Len: LongInt;
  Title: String;
begin
  Result := '';
  Len := GetWindowTextLength(hWindow) + 1;
  SetLength(Title, Len);
  GetWindowText(hWindow, PChar(Title), Len);
  Result := TrimRight(Title);
end;

function Eq(aValue1, aValue2: string): boolean;
begin
  Result := AnsiCompareText(Trim(aValue1),Trim(aValue2))=0;
end;

function GenSpaces(cnt: integer): string;
var
  i: integer;
  s: string;
begin
 s:='';
 for i := 0 to cnt -1 do
  begin
     s:=s+#32;
    end;
  result:=s;
end;

end.

