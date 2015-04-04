unit fmain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, dirwatch, Printers, Buttons, ExtCtrls, prtmodule;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    lblPrinter: TLabel;
    txtFolder: TEdit;
    Button1: TButton;
    DirectoryWatch1: TDirectoryWatch;
    OpenDialog1: TOpenDialog;
    btnClose: TBitBtn;
    btnPrint: TBitBtn;
    btnOpenFile: TBitBtn;
    procedure Button1Click(Sender: TObject);
    procedure txtFolderChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DirectoryWatch1Change(Sender: TObject);
    procedure btnOpenFileClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
  private
    { Private declarations }
    fdebug : boolean;
    function PrintFile(afile:string):boolean;
    procedure getfilelist();
    procedure PrintMemo();

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


function Tform1.PrintFile(afile:string):boolean;
var myFile:TextFile;
    s:string;
begin
  result := False;
  if fdebug then
    memo1.Lines.Add('Open File ');
  AssignFile(myFile, afile);
  Reset(myFile);
  if Not Eof(myfile) then
  begin
    try
      printer.BeginDoc;
      try
        while not Eof(myFile) do
        begin
          ReadLn(myFile, s);
          Memo1.Lines.Add(s);
          DirectToPrinter(s,True);
        end;
      finally
        printer.EndDoc;
        result := true;
        if fdebug then
          memo1.Lines.Add('End Printing');
      end
    except
      on e:exception do
      begin
        if fdebug then
          memo1.Lines.Add(e.message);
      end;
    end;
  end
  else
  begin
      if fdebug then
        memo1.Lines.Add('File Empty');
  end;
  CloseFile(myFile);
end;

procedure Tform1.PrintMemo();
var i:Longint;
    s:string;
begin
  printer.BeginDoc;
  try
    for i := 0 to memo1.Lines.Count-1 do
    begin
      s := memo1.lines[i];
      DirectToPrinter(s,True);
    end;
  finally
    printer.EndDoc;
  end;
end;

procedure TForm1.getfilelist();
var
  Path    : String;
  SR      : TSearchRec;
  filename : String;
begin
  Path:=DirectoryWatch1.Directory; //Get the path of the selected file
  try
    if FindFirst(Path + '*.prn', faArchive, SR) = 0 then
    begin
      repeat
        filename := path+SR.Name;
        Memo1.Lines.Clear;
        try
          if fdebug then
              memo1.Lines.Add('FileName: '+filename);
          if Printfile(filename) then
            if not deletefile(filename) then
            begin
              memo1.lines.add('File Not Deleted');
              exit;
            end;
        except
          on e:exception do
              memo1.lines.add(e.Message);
        end;
      until FindNext(SR) <> 0;
      FindClose(SR);
    end;
  finally
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if opendialog1.Execute then
  begin
      txtFolder.Text:=ExtractFilePath(OpenDialog1.FileName);;
  end;
end;

procedure TForm1.txtFolderChange(Sender: TObject);
begin
  if DirectoryWatch1.Active then
     DirectoryWatch1.Active :=False;
  DirectoryWatch1.Directory:=txtFolder.Text;
  try
     DirectoryWatch1.Active:=True;
  except
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  lblPrinter.Caption := GetDefaultPrinter;
  txtfolder.Text:= getTempDirectory;
  memo1.Clear;
  fdebug:=True;
  getfilelist;
end;

procedure TForm1.DirectoryWatch1Change(Sender: TObject);
begin
  getfilelist;
end;

procedure TForm1.btnOpenFileClick(Sender: TObject);
begin
  if opendialog1.Execute then
  begin
     Memo1.Clear;
     Memo1.Lines.LoadFromFile(opendialog1.FileName);
  end;
end;

procedure TForm1.btnCloseClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.btnPrintClick(Sender: TObject);
begin
  if Memo1.Lines.Count>0 then
  begin
    try
      PrintMemo()
    finally
      showmessage('Print Sukses');
    end;
  end
  else showmessage('Nothing to print');

end;

end.
