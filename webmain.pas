unit webmain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls, Sockets, IdBaseComponent,
  IdComponent, IdTCPServer, IdCustomHTTPServer, IdHTTPServer, IdGlobal,
  IdTCPClient, IdCoder, IdCoderMIME, IdException, prtmodule, printers,
  dirwatch,PrintUtils;
type
  TForm2 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Label3: TLabel;
    btnClose: TBitBtn;
    btnPrint: TBitBtn;
    btnOpenFile: TBitBtn;
    OpenDialog1: TOpenDialog;
    btnStart: TBitBtn;
    btnStop: TBitBtn;
    IdHTTPServer1: TIdHTTPServer;
    DirectoryWatch1: TDirectoryWatch;
    Label1: TLabel;
    lblTmpFolder: TLabel;
    btnFolder: TBitBtn;
    cboPrinters: TComboBox;
    PrinterSetupDialog1: TPrinterSetupDialog;
    btnPrinter: TBitBtn;
    Label4: TLabel;
    cboPaper: TComboBox;
    Label2: TLabel;
    cboFonts: TComboBox;
    chkCondensed: TCheckBox;
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure IdHTTPServer1CommandGet(AThread: TIdPeerThread;
      ARequestInfo: TIdHTTPRequestInfo;
      AResponseInfo: TIdHTTPResponseInfo);
    procedure FormCreate(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure DirectoryWatch1Change(Sender: TObject);
    procedure btnFolderClick(Sender: TObject);
    procedure cboPrintersChange(Sender: TObject);
    procedure btnPrinterClick(Sender: TObject);
    procedure btnOpenFileClick(Sender: TObject);
  private
    { Private declarations }
    procedure getfilelist();
    function getescstr():string;
    procedure setcbopaper();
  procedure PrintMemo();
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}
procedure TForm2.getfilelist();
var
  Path    : String;
  SR      : TSearchRec;
  filename,esc: String;
begin
  Path:=DirectoryWatch1.Directory; //Get the path of the selected file
  try
    esc := getescstr();
    if FindFirst(Path + '*.prn', faArchive, SR) = 0 then
    begin
      repeat
        filename := path+SR.Name;
        //Memo1.Lines.Clear;
        try
          //if fdebug then
          //    memo1.Lines.Add('FileName: '+filename);
          if Printfile(esc,filename) then
            if not deletefile(filename) then
            begin
              //memo1.lines.add('File Not Deleted');
              exit;
            end;
        except
          //on e:exception do
          //    memo1.lines.add(e.Message);
        end;
      until FindNext(SR) <> 0;
      FindClose(SR);
    end;
  finally
  end;
end;

procedure TForm2.btnStartClick(Sender: TObject);
begin
  Memo1.Clear;
  Memo1.Lines.Add('--LOG--');
  //IdHTTPServer1.Active:=True;
  Memo1.Lines.Add(DateTimeToStr(Now)+': Server started');
  if DirectoryWatch1.Active then
      DirectoryWatch1.Active:=False;

  DirectoryWatch1.Directory:= lblTmpFolder.Caption;
  DirectoryWatch1.Active:=True;

  btnStop.Enabled:=True;
  btnStart.Enabled:=Not btnStop.Enabled;
end;

procedure TForm2.btnStopClick(Sender: TObject);
begin
  //IdHTTPServer1.Active:=False;
  Memo1.Lines.Add(DateTimeToStr(Now)+': Server stopped');
  DirectoryWatch1.Active:=False;

  btnStop.Enabled:=False;
  btnStart.Enabled:=Not btnStop.Enabled;
end;

procedure TForm2.IdHTTPServer1CommandGet(AThread: TIdPeerThread;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);

var
  Line : String;
  responseMemoryStream, reqMemoryStream : TMemoryStream;
  value, filename, Path :String;
  values, HTMLStrings:TStrings;

begin
  memo1.Lines.Add(ARequestInfo.Document);
  memo1.Lines.Add(ARequestInfo.ContentType);

  Path := ARequestInfo.Document;
  if Path='/' then Path := '/index.html';

  responseMemoryStream := TMemoryStream.Create;
  reqMemoryStream := TMemoryStream.Create;
  try
    AResponseInfo.ContentType := 'text/html';
    AResponseInfo.ContentEncoding := 'UTF-8';
    if path='/cetak' then
    begin
      if ARequestInfo.Command = 'POST' then
      begin
        HTMLStrings:=TStringList.create;
        values := tstringlist.Create;
        values.add(ARequestInfo.Params.Values['text2print']);
        filename := ARequestInfo.Params.Values['filename'];
        try
          values.SaveToFile(DirectoryWatch1.Directory+'\'+filename);
          HTMLStrings.Add('{"success":true, "msg":"Success Kirim ke Printer"}')
        except
          HTMLStrings.Add('{"success":faslse, "msg":"Print Failed"}');
        end;
        values.Free;
        AResponseInfo.ContentText := HTMLStrings.Text;
      end
      else
      begin
        HTMLStrings:=TStringList.create;
        HTMLStrings.Add('{"success":false, "msg":"Nothing To Print"}');
        AResponseInfo.ContentText := HTMLStrings.Text;

      end;

    end
    else if FileExists('./html'+Path) then
    begin
      responseMemoryStream.LoadFromFile('./html/index.html');
      AResponseInfo.ContentStream := TMemoryStream.Create;
      TMemoryStream(AResponseInfo.ContentStream).LoadFromStream(responseMemoryStream);
    end
    else
    begin
        HTMLStrings:=TStringList.create;
        HTMLStrings.Add('<html><head><title>Not Found</title></head>');
        HTMLStrings.Add('<body><h1>Not Found</h1></body></html>');
        AResponseInfo.ContentText := HTMLStrings.Text;
    end;
  finally
    responseMemoryStream.Free;
    reqMemoryStream.Free;
  end;
end;

procedure TForm2.setcbopaper();
var
    i:integer;
    paperinfo:TPaperInfos;
    paper_id:smallint;
begin
  paper_id := GetPaper;

  cboPaper.Items.Clear;
  GetPaperInfo(paperinfo,Printer.PrinterIndex);
  for i:= 0 to length(paperinfo)-1 do
  begin
    cboPaper.Items.Add(paperinfo[i].papername);
    if paper_id = paperinfo[i].paperid then
       cboPaper.ItemIndex:= i;
  end;

end;

procedure TForm2.FormCreate(Sender: TObject);
var defPrinter:String;
    lPrinters:TPrinter;
begin
  //lPrinters:=TPrinter.Create;
  //defPrinter:=GetDefaultPrinter;
  cboPrinters.Items:=Printer.Printers;
  cboPrinters.ItemIndex:=Printer.PrinterIndex;
  setcbopaper();
  cboFonts.Items:=Printer.Fonts;
  cboFonts.ItemIndex:=0;

//  cboFonts.ItemIndex:=Printer.Canvas.Font.Size;
  lblTmpFolder.Caption:= getTempDirectory;
  btnStart.Click
end;

procedure Tform2.PrintMemo();
var i:Longint;
    s,sh:string;
begin
  printer.BeginDoc;
  try
    DirectToPrinter(getescstr,False);
    for i := 0 to memo1.Lines.Count-1 do
    begin
      s := memo1.lines[i];
      DirectToPrinter(s,True);
    end;
    {
      sh := 'Hello, World!';
      s := #27'P';    //SI 17
      DirectToPrinter(s,False);
      DirectToPrinter(sh,True);
      s := #27'M';    //SI 20
      DirectToPrinter(s,False);
      DirectToPrinter(sh,True);
      s := #27'g';
      DirectToPrinter(s,False);
      DirectToPrinter(sh,True);
      //s := #27'PSI' + 'Hello, World!';
      //DirectToPrinter(s,True);
      //s := #27'MSI' + 'Hello, World!';
      //DirectToPrinter(s,True);
     }

  finally
    printer.EndDoc;
  end;
end;

procedure TForm2.btnPrintClick(Sender: TObject);
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

procedure TForm2.DirectoryWatch1Change(Sender: TObject);
begin
  getfilelist;
end;

procedure TForm2.btnFolderClick(Sender: TObject);
var filepath:string;
begin
  if Opendialog1.Execute then
  begin
    btnStopClick(Sender);
    lblTmpFolder.Caption:=ExtractFilePath(OpenDialog1.FileName);
    btnStartClick(Sender);
  end;

end;
function TForm2.getescstr():string;
var prefix:string;
begin
  result:='';
  //if cboFonts.ItemIndex=0 then
  //   prefix := #27#80 //10 cpi
  //else if cboFonts.ItemIndex=1 then
  //   prefix := #27#77; //10 cpi
  if chkCondensed.Checked then
     result := #27#15
  else
     result := #27#64;
end;

procedure TForm2.cboPrintersChange(Sender: TObject);
begin
  //getescstr();
end;

procedure TForm2.btnPrinterClick(Sender: TObject);
begin
  if PrinterSetupDialog1.Execute then
  begin
     cboPrinters.ItemIndex:=Printer.PrinterIndex;
     setcbopaper();
  end;
end;

procedure TForm2.btnOpenFileClick(Sender: TObject);
var sh, s:string;
begin
opendialog1.InitialDir:=lbltmpFolder.Caption;
//opendialog1.Filter:=
if opendialog1.Execute then
begin
  memo1.Lines.LoadFromFile(opendialog1.FileName);
  //printmemo();
end;
{27 33 n
            0  Pica		 16  Double Strike
				    1  Elite		 32  Double Wide
				    4  Condensed	 64  Italic
				    8  Emphasized	128  Underline
27 77	    ESC M	  Select elite width (12 cpi)
27 80	    ESC P	  Select pica width (10 cpi)
27 103	    ESC g	  Select pica width (10 cpi)

} {
  printer.BeginDoc;
  try
      sh := 'Hello, World!';
      s := #27#33'4'+sh;    //SI 17
      DirectToPrinter(s,False);
      {s := #27#80' ';    //SI 17
      DirectToPrinter(s,False);
      DirectToPrinter(sh,True);

      s := #27#77' ';    //SI 20
      DirectToPrinter(s,False);
      DirectToPrinter(sh,True);

      s := #27#103' ';
      DirectToPrinter(s,False);
      DirectToPrinter(sh,True);

      //s := #27'PSI' + 'Hello, World!';
      //DirectToPrinter(s,True);
      //s := #27'MSI' + 'Hello, World!';
      //DirectToPrinter(s,True);        }

   {
  finally
    printer.EndDoc;
  end;}
end;

end.

