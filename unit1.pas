unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, IniFiles, Functions,
  ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private

  public
    Delimiter, DelimiterReplace, InputFile, OutputFile, ErrorMessage, Tags: String;
    StartFromLine: Integer;
    BTrim, RemoveDuplicateSpaces: Boolean;
    t: TStringList;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var StartDir: String;
  ini: TINIFile;
begin
  StartDir := ExtractFilePath(ParamStr(0));
  ErrorMessage := '';

  ini := TINIFile.Create(StartDir + 'config.ini');
  Delimiter := ini.ReadString('Main', 'Delimiter', ';');
  DelimiterReplace := ini.ReadString('Main', 'DelimiterReplace', ',');
  StartFromLine := ini.ReadInteger('Main', 'StartFromLine', 3);
  InputFile := ini.ReadString('Main', 'InputFile', '');
  OutputFile := ini.ReadString('Main', 'OutputFile', '');
  BTrim := ini.ReadBool('Main', 'Trim', True);
  RemoveDuplicateSpaces := ini.ReadBool('Main', 'RemoveDuplicateSpaces', True);
  Tags := ini.ReadString('Main', 'Tags', '');

  if InputFile = '' then ErrorMessage := 'Error! Parameter InputFile in config.ini is empty.';
  if OutputFile = '' then ErrorMessage := 'Error! Parameter OutputFile in config.ini is empty.';
  if Tags = '' then ErrorMessage := 'Error! Parameter Tags in config.ini is empty.';
  if InputFile = OutputFile then ErrorMessage := 'Error in config.ini InputFile = OutputFile';
  if Delimiter = DelimiterReplace then ErrorMessage := 'Error in config.ini Delimiter = DelimiterReplace';
  if FileExists(StartDir + 'config.ini') = false then ErrorMessage := 'Error! File config.ini does not exists!';

end;

procedure TForm1.Button1Click(Sender: TObject);
var f1, f2: TextFile;
  s, line, item: String;
  i, i2, k, j: Integer;
  tm, tm1: DWORD;
begin

  if ErrorMessage <> '' then begin
    ShowMessage(ErrorMessage);
    Exit;
  end;

  i := 1;
  i2 := 0;
  k := 0;
  tm1 := GetTickCount64;
  Button1.Visible := False;
  Label1.Caption := 'Create CSV from XML ...';
  Application.ProcessMessages;
  if FileExists(InputFile) = False then begin
    ShowMessage('Error! File ' + InputFile + ' does not exists!');
    Exit;
  end;
  t := TStringlist.Create;
  t.Delimiter := ',';
  t.DelimitedText := Tags;
  AssignFile(f1, InputFile);
  AssignFile(f2, OutputFile);
  Reset(f1);
  Rewrite(f2);
  while not EOF(f1) do begin
    ReadLn(f1, s);

    line := '';
    for j:=0 to t.Count-1 do begin
      item := getItem(s, t[j], Delimiter, DelimiterReplace, BTrim, RemoveDuplicateSpaces);
      line := line + item + Delimiter;
    end;

    if (i >= StartFromLine) then WriteLn(f2, line);
    inc(i);
    inc(k);
    if k >= 100000 then begin
      k := 0;
      inc(i2);
      Label2.Caption := IntToStr(i2) + ' * 100k';
      Application.ProcessMessages;
    end;
  end;
  CloseFile(f1);
  CloseFile(f2);
  Label3.Caption := 'Finish! Loaded ' + IntToStr(i-StartFromLine) + ' records';
  tm := GetTickCount64 - tm1;
  Label4.Caption := 'Time: ' + FloatToStr(Round(tm/1000)) + ' sec';
end;

end.

