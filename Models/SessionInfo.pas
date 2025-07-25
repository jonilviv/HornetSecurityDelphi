unit SessionInfo;

interface

uses
  Winapi.Windows,
  Winapi.Wtsapi32,
  System.Classes;

type
  TSessionInfo = record
    SessionId: DWORD;
    StationName: string;
    State: WTS_CONNECTSTATE_CLASS;
    UserName: string;
  end;

implementation

end.
