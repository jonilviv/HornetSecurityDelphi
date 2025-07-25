unit ProcessService;

interface

uses
  Win32_Process,
  System.Generics.Collections;

type
  IProcessService = interface
    function GetWin32Processes: TArray<TWin32_Process>;
  end;

type
  TProcessService = class(TInterfacedObject, IProcessService)
  public
    function GetWin32Processes: TArray<TWin32_Process>;
  end;

implementation

uses
  ActiveX,
  ComObj,
  Tools,
  Variants,
  System.SysUtils;

function TProcessService.GetWin32Processes: TArray<TWin32_Process>;
var
  processList: TList<TWin32_Process>;
  proc: TWin32_Process;
  locator: OleVariant;
  server: OleVariant;
  services: OleVariant;
  unknown: IUnknown;
  enum: IEnumVARIANT;
  item: OleVariant;
  fetched: LongWord;
begin
  try
    begin
      CoInitialize(nil);
      processList := TList<TWin32_Process>.Create;

      try
        locator := CreateOleObject('WbemScripting.SWbemLocator');
        server := locator.ConnectServer('localhost', 'root\CIMV2');
        services := server.ExecQuery('SELECT * FROM Win32_Process');
        unknown := IUnknown(services._NewEnum);
        unknown.QueryInterface(IEnumVARIANT, enum);

        VarClear(locator);
        VarClear(server);
        VarClear(services);
        unknown := nil;

        while enum.Next(1, item, fetched) = S_OK do
          begin
            try
              proc := TWin32_Process.Create;
              proc.Caption := VariantToSafeString(item.Caption);
              proc.CommandLine := VariantToSafeString(item.CommandLine);
              proc.CreationClassName := item.CreationClassName;
              // proc.CreationDate := VariantToSafeDateTime(item.CreationDate);
              proc.Description := VariantToSafeString(item.Description);
              proc.ExecutablePath := VariantToSafeString(item.ExecutablePath);
              proc.Handle := VariantToSafeUInt32(item.Handle);
              proc.HandleCount := VariantToSafeUInt32(item.HandleCount);
              proc.KernelModeTime := item.KernelModeTime;
              proc.Name := VariantToSafeString(item.Name);
              proc.ParentProcessId := VariantToSafeUInt32(item.ParentProcessId);
              proc.PeakVirtualSize := VariantToSafeUInt64(item.PeakVirtualSize);
              proc.PeakWorkingSetSize := VariantToSafeUInt64(item.PeakWorkingSetSize);
              proc.Priority := VariantToSafeUInt32(item.Priority);
              proc.ProcessId := VariantToSafeUInt32(item.ProcessId);
              proc.ThreadCount := VariantToSafeUInt32(item.ThreadCount);
              proc.UserModeTime := VariantToSafeUInt64(item.UserModeTime);
              proc.WorkingSetSize := VariantToSafeUInt64(item.WorkingSetSize);

              processList.Add(proc);
            finally
              // item := Unassigned;
              VarClear(item);
            end;
          end;

        Result := processList.ToArray;
      finally
        processList.Clear;
        FreeAndNil(processList);
        CoUninitialize;
      end;
    end;
  except
    on E: Exception do
  end;
end;

end.
