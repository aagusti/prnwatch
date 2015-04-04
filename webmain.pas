unit webmain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls, Sockets, IdBaseComponent,
  IdComponent, IdTCPServer, IdCustomHTTPServer, IdHTTPServer, IdGlobal,
  IdTCPClient, IdCoder, IdCoderMIME, IdException, prtmodule, printers,
  dirwatch;
type
  TForm2 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Label3: TLabel;
    lblPrinter: TLabel;
    btnClose: TBitBtn;
    btnPrint: TBitBtn;
    btnOpenFile: TBitBtn;
    OpenDialog1: TOpenDialog;
    btnStart: TBitBtn;
    BitBtn1: TBitBtn;
    IdHTTPServer1: TIdHTTPServer;
    DirectoryWatch1: TDirectoryWatch;
    procedure btnStartClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure IdHTTPServer1CommandGet(AThread: TIdPeerThread;
      ARequestInfo: TIdHTTPRequestInfo;
      AResponseInfo: TIdHTTPResponseInfo);
    procedure FormCreate(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure DirectoryWatch1Change(Sender: TObject);
  private
    { Private declarations }
    procedure getfilelist();
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
  filename : String;
begin
  Path:=DirectoryWatch1.Directory; //Get the path of the selected file
  try
    if FindFirst(Path + '*.prn', faArchive, SR) = 0 then
    begin
      repeat
        filename := path+SR.Name;
        //Memo1.Lines.Clear;
        try
          //if fdebug then
          //    memo1.Lines.Add('FileName: '+filename);
          if Printfile(filename) then
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
  IdHTTPServer1.Active:=True;
  Memo1.Lines.Add(DateTimeToStr(Now)+': Server started');
  DirectoryWatch1.Active:=True;
end;

procedure TForm2.BitBtn1Click(Sender: TObject);
begin
  IdHTTPServer1.Active:=False;
  Memo1.Lines.Add(DateTimeToStr(Now)+': Server stopped');
  DirectoryWatch1.Active:=False;
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
procedure TForm2.FormCreate(Sender: TObject);
begin
  lblPrinter.Caption:=GetDefaultPrinter;
  DirectoryWatch1.Directory:= getTempDirectory;
btnStart.Click
end;

procedure Tform2.PrintMemo();
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

end.
