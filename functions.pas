unit Functions;

interface

uses
  SysUtils;

function getItem(s, item, d, dr: String; BTrim, RemoveDuplicateSpaces: Boolean): String;
function DeleteRepeatedSpaces(const s: string): string;

implementation

function getItem(s, item, d, dr: String; BTrim, RemoveDuplicateSpaces: Boolean): String;
var
  p1, p2: Integer;
  r: String;
begin
  p1 := pos('<' + UpperCase(item) + '>', UpperCase(s));
  p2 := pos('</' + UpperCase(item) + '>', UpperCase(s));

  r := copy(s, p1 + length(item) + 2, p2 - p1 - length(item) - 2);
  r := StringReplace(r, d, dr, [rfReplaceAll]);

  if BTrim then r := trim(r);
  if RemoveDuplicateSpaces then r := DeleteRepeatedSpaces(r);

  Result := r;
end;

function DeleteRepeatedSpaces(const s: string): string;
var
  i, j, State: Integer;
begin
  SetLength(Result, Length(s));
  j := 0;
  State := 0;

  for i := 1 to Length(s) do begin

    if s[i] = ' ' then
      Inc(State)
    else
      State := 0;

    if State < 2 then
      Result[i - j] := s[i]
    else
      Inc(j);

  end;

  if j > 0 then
      SetLength(Result, Length(s) - j);
end;

end.
