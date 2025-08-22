unit MainPresenter;

interface

uses
  MainView,
  ProcessService,
  SessionsService,
  SHA256Service,
  Win32_Process,
  Winapi.Wtsapi32;

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
    function SessionStateToString(const State: WTS_CONNECTSTATE_CLASS): string;
  public
    constructor Create(AView: IMainView; ProcessService: IProcessService; SessionService: ISessionService; SHA256Service: ISHA256Service);
  end;

implementation

uses
  SessionInfo,
  System.Classes,
  System.SysUtils,
  System.TypInfo;

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
        rows[0] := 'Session state: ' + SessionStateToString(Selection.Session.State);
        _view.ShowProperties(rows);
      end
  else
    _view.ClearProperties;
  end;
end;

{*
  WTS_CONNECTSTATE_CLASS values and their meanings
  Reference: https://learn.microsoft.com/en-us/windows/win32/api/wtsapi32/ne-wtsapi32-wts_connectstate_class
  
  WTSActive (0) - User is logged on to the WinStation
  WTSConnected (1) - WinStation is connected to the client
  WTSConnectQuery (2) - WinStation is in the process of connecting to the client
  WTSShadow (3) - WinStation is shadowing another WinStation
  WTSDisconnected (4) - WinStation is active but the client is disconnected
  WTSIdle (5) - WinStation is waiting for a client to connect
  WTSListen (6) - WinStation is listening for a connection
  WTSReset (7) - WinStation is being reset
  WTSDown (8) - WinStation is down due to an error
  WTSInit (9) - WinStation is initializing
*}
function TMainPresenter.SessionStateToString(const State: WTS_CONNECTSTATE_CLASS): string;
begin
  case State of
    WTSActive: Result := '0 - Active: User logged on';
    WTSConnected: Result := '1 - Connected: Connected to client';
    WTSConnectQuery: Result := '2 - Connect Query: Connecting to client';
    WTSShadow: Result := '3 - Shadow: Shadowing another session';
    WTSDisconnected: Result := '4 - Disconnected: Active but client disconnected';
    WTSIdle: Result := '5 - Idle: Waiting for client connection';
    WTSListen: Result := '6 - Listen: Listening for connection';
    WTSReset: Result := '7 - Reset: Being reset';
    WTSDown: Result := '8 - Down: Down due to error';
    WTSInit: Result := '9 - Init: Initializing';
  else
    Result := Ord(State).ToString + ' - Unknown: Undefined state';
  end;
end;

end.
