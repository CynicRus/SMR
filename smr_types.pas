unit smr_types;

{$mode objfpc}{$H+}

interface
 uses Classes,SysUtils;
type
 THookItem = class(TCollectionItem)
    Public
      ItemType: boolean;//true - mouse,false - keyboard
      //keyboard
      VirtualKey: string;
      PressedTime: integer;
      KeyCode: integer;
      //mouse
      ClickCoord: TPoint;
      {
      0 - mouse left down;
      1 - mouse left up;
      2 - mouse left double click;
      3 - mouse right down;
      4 - mouse right up;
      5 - mouse middle down;
      6 - mouse middle up;
      }
      ClickType: integer;
      WaitingTime: integer;
      //
      constructor Create(Col: TCollection); override;
      destructor Destroy; override;
  end;

  THookItemList = class(TCollection)
    function GetItems(Index: Integer):  THookItem;
   public
     function AddItem:  THookItem;
     constructor Create;
     property Items[Index: Integer]:  THookItem read GetItems; default;
  end;

implementation

{ THookItem }

constructor THookItem.Create(Col: TCollection);
begin
  inherited Create(Col);
end;

destructor THookItem.Destroy;
begin
  inherited Destroy;
end;

{ THookItemList }

function THookItemList.AddItem: THookItem;
begin
  Result := THookItem(inherited Add())
end;

constructor THookItemList.Create;
begin
  inherited Create(THookItem);
end;

function THookItemList.GetItems(Index: Integer): THookItem;
begin
   Result := THookItem(inherited Items[Index]);
end;

end.


