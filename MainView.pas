unit MainView;

interface

uses
  SessionInfo,
  Win32_Process,
  Winapi.Wtsapi32,
  System.Generics.Collections;

type
  TTimerTickEvent = procedure of object;
  TCalculateSHA256Event = procedure of object;
  TNodeKind = (nkNone, nkProcess, nkSession);

  TTreeSelection = record
    Kind: TNodeKind;
    Process: TWin32_Process;
    Session: TSessionInfo;
  end;

  TSelectionChangedEvent = procedure(const Selection: TTreeSelection) of object;

  IMainView = interface

    // Events
    procedure SetOnCalculateFilesHash256(const AHandler: TCalculateSHA256Event);
    procedure SetOnTreeSelectionChanged(const AHandler: TSelectionChangedEvent);
    procedure SetOnTimerTick(const AHandler: TTimerTickEvent);

    // Progress Bar
    procedure ResetProgressBar;
    procedure InitProgressBar(MaxValue: Integer);
    procedure IncrementProgressBar(Progress: Integer);

    // Text
    procedure ResetText;
    procedure AddTextLine(const TextLine: string);

    // Buttons
    procedure DisableCalculateSHA256Button;
    procedure EnableCalculateSHA256Button;

    // TreeView update
    procedure SetProcessesNodes(processes: TArray<TWin32_Process>);
    procedure SetSessionsNodes(sessions: TArray<TSessionInfo>);

    // Property grid / inspector
    procedure ShowProperties(const rows: TArray<string>);
    procedure ClearProperties;
  end;

implementation

end.
