program HornetSecurity;

uses
  Vcl.Forms,
  CIM_LogicalElement in 'Models\CIM_LogicalElement.pas',
  CIM_ManagedSystemElement in 'Models\CIM_ManagedSystemElement.pas',
  CIM_Process in 'Models\CIM_Process.pas',
  ExecutionState in 'Models\ExecutionState.pas',
  Main in 'Main.pas' {FormMain} ,
  MainPresenter in 'MainPresenter.pas',
  MainView in 'MainView.pas',
  ProcessService in 'Services\ProcessService.pas',
  SessionInfo in 'Models\SessionInfo.pas',
  SessionsService in 'Services\SessionsService.pas',
  SHA256Service in 'Services\SHA256Service.pas',
  Tools in 'Tools.pas',
  Win32_Process in 'Models\Win32_Process.pas';

{$R *.res}

var
  view: TFormMain;
  presenter: TMainPresenter;
  procService: IProcessService;
  sessionService: ISessionService;
  sha256Service: ISHA256Service;

begin
  procService := TProcessService.Create();
  sessionService := TSessionService.Create();
  sha256Service := TSHA256Service.Create();

  Application.Initialize;
  Application.MainFormOnTaskBar := True;
  Application.ShowMainForm := True;
  Application.CreateForm(TFormMain, view);
  presenter := TMainPresenter.Create(view, procService, sessionService, sha256Service);

  Application.Run;

end.
