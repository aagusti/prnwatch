program web2dm;

uses
  Forms,
  prtmodule in 'prtmodule.pas',
  webmain in 'webmain.pas' {Form2};

{$R *.res}

begin
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
