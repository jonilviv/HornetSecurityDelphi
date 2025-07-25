unit SHA256Service;

interface

type
  ISHA256Service = interface
    function GetFileSHA256(const fileName: string): string;
  end;

type
  TSHA256Service = class(TInterfacedObject, ISHA256Service)
  public
    function GetFileSHA256(const fileName: string): string;
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  System.Hash;

function TSHA256Service.GetFileSHA256(const fileName: string): string;
const
  bufferSize = 1024 * 1024; // 1 MB
var
  fs: TFileStream;
  Hash: THashSHA2;
  buffer: TBytes;
  bytesRead: Integer;
begin
  if fileName = ''
  then
    begin
      raise Exception.Create('File name must be cpecified: %s');
      Exit;
    end;

  if not FileExists(fileName)
  then
    begin
      raise Exception.CreateFmt('File not found: %s', [fileName]);
      Exit;
    end;

  fs := TFileStream.Create(fileName, fmOpenRead or fmShareDenyWrite);

  try
    Hash := THashSHA2.Create(THashSHA2.TSHA2Version.SHA256);
    SetLength(buffer, bufferSize);

    repeat
      bytesRead := fs.Read(buffer[0], bufferSize);

      if bytesRead > 0
      then
        Hash.Update(buffer, bytesRead);

    until bytesRead = 0;

    Result := Hash.HashAsString;
  finally
    fs.Free;
  end;
end;

end.
