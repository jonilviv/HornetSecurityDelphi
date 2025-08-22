unit MainPresenter;

interface

uses
  MainView,
  ProcessService,
  SessionsService,
  SHA256Service,
  Win32_Process;

type
  TMainPresenter = class
  private
    _view: IMainView;
    _processService: IProcessService;
    _sessionService: ISessionService;
    _sha256Service: ISHA256Service;
    _processes: TArray<TWin32_Process>;

    procedure OnTimerTick;
    procedure OnCalculateSHA256Click;
    procedure OnSelectionChanged(const Selection: TTreeSelection);
  public
    constructor Create(AView: IMainView; ProcessService: IProcessService; SessionService: ISessionService; SHA256Service: ISHA256Service);
  end;

implementation

uses
  SessionInfo,
  System.Classes,
  System.SysUtils,
  System.TypInfo,
  Winapi.Wtsapi32;

constructor TMainPresenter.Create(AView: IMainView; ProcessService: IProcessService; SessionService: ISessionService; SHA256Service: ISHA256Service);
begin
  _view := AView;
  _processService := ProcessService;
  _sessionService := SessionService;
  _sha256Service := SHA256Service;

  _view.ResetProgressBar();
  _view.ResetText();
  _view.DisableCalculateSHA256Button();
  _view.SetOnTimerTick(OnTimerTick);
  _view.SetOnCalculateFilesHash256(OnCalculateSHA256Click);
  _view.SetOnTreeSelectionChanged(OnSelectionChanged);
end;

procedure TMainPresenter.OnTimerTick();
var
  sessions: TArray<TSessionInfo>;
  threadProcs: TThread;
  threadSessions: TThread;
begin

  threadProcs := TThread.CreateAnonymousThread(
    procedure
    begin
      TThread.Synchronize(nil,
        procedure
        begin
          _view.DisableCalculateSHA256Button();
        end);

      _processes := _processService.GetWin32Processes;

      TThread.Synchronize(nil,
        procedure
        begin
          _view.SetProcessesNodes(_processes);
          _view.EnableCalculateSHA256Button();
        end);
    end);

  threadSessions := TThread.CreateAnonymousThread(
    procedure
    begin
      sessions := _sessionService.GetAllSessions;

      TThread.Synchronize(nil,
        procedure
        begin
          _view.SetSessionsNodes(sessions);
        end);
    end);

  threadProcs.FreeOnTerminate := True;
  threadSessions.FreeOnTerminate := True;

  threadProcs.Start;
  threadSessions.Start;
end;

procedure TMainPresenter.OnCalculateSHA256Click;
var
  sha, s: string;
  thread: TThread;
  l: Integer;
  run: Boolean;
begin
  _view.ResetText;
  l := Length(_processes);
  _view.InitProgressBar(l);

  thread := TThread.CreateAnonymousThread(
    procedure
    var
      i: Integer;
    begin
      for i := 0 to l - 1 do
        begin
          try
            sha := _sha256Service.GetFileSHA256(_processes[i].ExecutablePath);

            TThread.Synchronize(nil,
              procedure
              begin
                s := Format('%s - %s', [sha, _processes[i].ExecutablePath]);
                _view.AddTextLine(s);
              end);
          except
            on E: Exception do
              // _view.AddTextLine('ERROR: ' + E.Message);
          end;

          TThread.Synchronize(nil,
            procedure
            begin
              _view.IncrementProgressBar(i);
            end);
        end;

      TThread.Synchronize(nil,
        procedure
        begin
          _view.ResetProgressBar;
        end);
    end);

  thread.FreeOnTerminate := True;
  thread.Start;
end;

procedure TMainPresenter.OnSelectionChanged(const Selection: TTreeSelection);
var
  rows: TArray<string>;
begin
  case Selection.Kind of
    nkProcess:
      begin
        SetLength(rows, 3);
        rows[0] := 'Executable: ' + Selection.Process.ExecutablePath;
        rows[1] := 'Process ID: ' + Selection.Process.ProcessId.ToString;
        rows[2] := 'Session ID: ' + Selection.Process.SessionId.ToString;
        _view.ShowProperties(rows);
      end;
    nkSession:
      begin
        SetLength(rows, 1);
        rows[0] := 'Session state: ' + GetEnumName(TypeInfo(WTS_CONNECTSTATE_CLASS), Ord(Selection.Session.State));
        _view.ShowProperties(rows);
      end
  else
    _view.ClearProperties;
  end;
end;

end.
