program TestSendGridVCL;

uses
  Vcl.Forms,
  fApp in 'fApp.pas' {frmApp},
  Lib.Entidade.SendEmailToSendGrid in '..\..\Src\SendGrid\Lib.Entidade.SendEmailToSendGrid.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown:=True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmApp, frmApp);
  Application.Run;
end.
