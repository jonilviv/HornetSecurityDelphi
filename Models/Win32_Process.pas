unit Win32_Process;

interface

uses
  CIM_Process;

type
  // Processes
  // https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/cim-process
  TWin32_Process = class(TCIM_Process)
  private
    FCommandLine: string;
    FCommandLineValid: Boolean;

    FExecutablePath: string;
    FExecutablePathValid: Boolean;

    FHandleCount: Cardinal;
    FHandleCountValid: Boolean;

    FMaximumWorkingSetSize: UInt64;
    FMaximumWorkingSetSizeValid: Boolean;

    FMinimumWorkingSetSize: UInt64;
    FMinimumWorkingSetSizeValid: Boolean;

    FOtherOperationCount: UInt64;
    FOtherOperationCountValid: Boolean;

    FOtherTransferCount: UInt64;
    FOtherTransferCountValid: Boolean;

    FPageFaults: Cardinal;
    FPageFaultsValid: Boolean;

    FPageFileUsage: Cardinal;
    FPageFileUsageValid: Boolean;

    FParentProcessId: Cardinal;
    FParentProcessIdValid: Boolean;

    FPeakPageFileUsage: Cardinal;
    FPeakPageFileUsageValid: Boolean;

    FPeakVirtualSize: UInt64;
    FPeakVirtualSizeValid: Boolean;

    FPeakWorkingSetSize: UInt64;
    FPeakWorkingSetSizeValid: Boolean;

    FPrivatePageCount: UInt64;
    FPrivatePageCountValid: Boolean;

    FProcessId: Cardinal;
    FProcessIdValid: Boolean;

    FQuotaNonPagedPoolUsage: UInt64;
    FQuotaNonPagedPoolUsageValid: Boolean;

    FQuotaPagedPoolUsage: UInt64;
    FQuotaPagedPoolUsageValid: Boolean;

    FQuotaPeakNonPagedPoolUsage: UInt64;
    FQuotaPeakNonPagedPoolUsageValid: Boolean;

    FQuotaPeakPagedPoolUsage: UInt64;
    FQuotaPeakPagedPoolUsageValid: Boolean;

    FReadOperationCount: UInt64;
    FReadOperationCountValid: Boolean;

    FReadTransferCount: UInt64;
    FReadTransferCountValid: Boolean;

    FSessionId: Cardinal;
    FSessionIdValid: Boolean;

    FThreadCount: Cardinal;
    FThreadCountValid: Boolean;

    FVirtualSize: UInt64;
    FVirtualSizeValid: Boolean;

    FWindowsVersion: string;
    FWindowsVersionValid: Boolean;

    FWriteOperationCount: UInt64;
    FWriteOperationCountValid: Boolean;

    FWriteTransferCount: UInt64;
    FWriteTransferCountValid: Boolean;
  public
    property CommandLine: string read FCommandLine write FCommandLine;
    property CommandLineValid: Boolean read FCommandLineValid write FCommandLineValid;

    property ExecutablePath: string read FExecutablePath write FExecutablePath;
    property ExecutablePathValid: Boolean read FExecutablePathValid write FExecutablePathValid;

    property HandleCount: Cardinal read FHandleCount write FHandleCount;
    property HandleCountValid: Boolean read FHandleCountValid write FHandleCountValid;

    property MaximumWorkingSetSize: UInt64 read FMaximumWorkingSetSize write FMaximumWorkingSetSize;
    property MaximumWorkingSetSizeValid: Boolean read FMaximumWorkingSetSizeValid write FMaximumWorkingSetSizeValid;

    property MinimumWorkingSetSize: UInt64 read FMinimumWorkingSetSize write FMinimumWorkingSetSize;
    property MinimumWorkingSetSizeValid: Boolean read FMinimumWorkingSetSizeValid write FMinimumWorkingSetSizeValid;

    property OtherOperationCount: UInt64 read FOtherOperationCount write FOtherOperationCount;
    property OtherOperationCountValid: Boolean read FOtherOperationCountValid write FOtherOperationCountValid;

    property OtherTransferCount: UInt64 read FOtherTransferCount write FOtherTransferCount;
    property OtherTransferCountValid: Boolean read FOtherTransferCountValid write FOtherTransferCountValid;

    property PageFaults: Cardinal read FPageFaults write FPageFaults;
    property PageFaultsValid: Boolean read FPageFaultsValid write FPageFaultsValid;

    property PageFileUsage: Cardinal read FPageFileUsage write FPageFileUsage;
    property PageFileUsageValid: Boolean read FPageFileUsageValid write FPageFileUsageValid;

    property ParentProcessId: Cardinal read FParentProcessId write FParentProcessId;
    property ParentProcessIdValid: Boolean read FParentProcessIdValid write FParentProcessIdValid;

    property PeakPageFileUsage: Cardinal read FPeakPageFileUsage write FPeakPageFileUsage;
    property PeakPageFileUsageValid: Boolean read FPeakPageFileUsageValid write FPeakPageFileUsageValid;

    property PeakVirtualSize: UInt64 read FPeakVirtualSize write FPeakVirtualSize;
    property PeakVirtualSizeValid: Boolean read FPeakVirtualSizeValid write FPeakVirtualSizeValid;

    property PeakWorkingSetSize: UInt64 read FPeakWorkingSetSize write FPeakWorkingSetSize;
    property PeakWorkingSetSizeValid: Boolean read FPeakWorkingSetSizeValid write FPeakWorkingSetSizeValid;

    property PrivatePageCount: UInt64 read FPrivatePageCount write FPrivatePageCount;
    property PrivatePageCountValid: Boolean read FPrivatePageCountValid write FPrivatePageCountValid;

    property ProcessId: Cardinal read FProcessId write FProcessId;
    property ProcessIdValid: Boolean read FProcessIdValid write FProcessIdValid;

    property QuotaNonPagedPoolUsage: UInt64 read FQuotaNonPagedPoolUsage write FQuotaNonPagedPoolUsage;
    property QuotaNonPagedPoolUsageValid: Boolean read FQuotaNonPagedPoolUsageValid write FQuotaNonPagedPoolUsageValid;

    property QuotaPagedPoolUsage: UInt64 read FQuotaPagedPoolUsage write FQuotaPagedPoolUsage;
    property QuotaPagedPoolUsageValid: Boolean read FQuotaPagedPoolUsageValid write FQuotaPagedPoolUsageValid;

    property QuotaPeakNonPagedPoolUsage: UInt64 read FQuotaPeakNonPagedPoolUsage write FQuotaPeakNonPagedPoolUsage;
    property QuotaPeakNonPagedPoolUsageValid: Boolean read FQuotaPeakNonPagedPoolUsageValid write FQuotaPeakNonPagedPoolUsageValid;

    property QuotaPeakPagedPoolUsage: UInt64 read FQuotaPeakPagedPoolUsage write FQuotaPeakPagedPoolUsage;
    property QuotaPeakPagedPoolUsageValid: Boolean read FQuotaPeakPagedPoolUsageValid write FQuotaPeakPagedPoolUsageValid;

    property ReadOperationCount: UInt64 read FReadOperationCount write FReadOperationCount;
    property ReadOperationCountValid: Boolean read FReadOperationCountValid write FReadOperationCountValid;

    property ReadTransferCount: UInt64 read FReadTransferCount write FReadTransferCount;
    property ReadTransferCountValid: Boolean read FReadTransferCountValid write FReadTransferCountValid;

    property SessionId: Cardinal read FSessionId write FSessionId;
    property SessionIdValid: Boolean read FSessionIdValid write FSessionIdValid;

    property ThreadCount: Cardinal read FThreadCount write FThreadCount;
    property ThreadCountValid: Boolean read FThreadCountValid write FThreadCountValid;

    property VirtualSize: UInt64 read FVirtualSize write FVirtualSize;
    property VirtualSizeValid: Boolean read FVirtualSizeValid write FVirtualSizeValid;

    property WindowsVersion: string read FWindowsVersion write FWindowsVersion;
    property WindowsVersionValid: Boolean read FWindowsVersionValid write FWindowsVersionValid;

    property WriteOperationCount: UInt64 read FWriteOperationCount write FWriteOperationCount;
    property WriteOperationCountValid: Boolean read FWriteOperationCountValid write FWriteOperationCountValid;

    property WriteTransferCount: UInt64 read FWriteTransferCount write FWriteTransferCount;
    property WriteTransferCountValid: Boolean read FWriteTransferCountValid write FWriteTransferCountValid;
  end;

implementation

end.
