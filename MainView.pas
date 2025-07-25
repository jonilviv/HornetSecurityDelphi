unit MainView;

interface

uses
  SessionInfo,
  Win32_Process;

type
  TTimerTickEvent = procedure of object;
  TCalculateSHA256Event = procedure of object;

  IMainView = interface

    // Events
    procedure SetOnCalculateFilesHash256(const AHandler: TCalculateSHA256Event);
    // procedure SetOnTreeViewNodeClick(const AHandler: TActionObject);
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
    procedure SetProperty(const SelectedObject: TObject);
  end;

implementation

end.
