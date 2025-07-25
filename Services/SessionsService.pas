unit SessionsService;

interface

uses
  SessionInfo,
  System.Generics.Collections;

type
  ISessionService = interface
    function GetAllSessions: TArray<TSessionInfo>;
  end;

type
  TSessionService = class(TInterfacedObject, ISessionService)
  public
    function GetAllSessions: TArray<TSessionInfo>;
  end;

implementation

uses
  Winapi.Windows,
  Winapi.Wtsapi32;

{ TSessionService }

function TSessionService.GetAllSessions: TArray<TSessionInfo>;
var
  ppSessionInfo: PWTS_SESSION_INFO;
  session: WTS_SESSION_INFO;
  SessionInfo: TSessionInfo;
  sessions: TList<TSessionInfo>;
  count, i: DWORD;
  dataSize: Integer;
  userName: LPWSTR;
  userNameLength: DWORD;
begin
  sessions := TList<TSessionInfo>.Create;
  ppSessionInfo := nil;
  count := 0;

  if WTSEnumerateSessions(WTS_CURRENT_SERVER_HANDLE, 0, 1, ppSessionInfo, count)
  then
    begin
      dataSize := SizeOf(WTS_SESSION_INFO);

      for i := 0 to count - 1 do
        begin
          session := PWTS_SESSION_INFO(NativeUInt(ppSessionInfo) + NativeUInt(i) * NativeUInt(dataSize))^;

          SessionInfo.SessionId := session.SessionId;
          SessionInfo.StationName := string(session.pWinStationName);
          SessionInfo.State := session.State;

          userName := nil;
          userNameLength := 0;

          if WTSQuerySessionInformation(WTS_CURRENT_SERVER_HANDLE, SessionInfo.SessionId, WTSUserName, userName, userNameLength)
          then
            begin
              SessionInfo.userName := string(userName);

              WTSFreeMemory(userName);
            end;

          sessions.Add(SessionInfo);
        end;

      WTSFreeMemory(ppSessionInfo);
    end;

  Result := sessions.ToArray;
  // FreeAndNil() sessions
end;

end.
