unit Tools;

interface

function VariantToSafeUInt32(value: OleVariant): UInt32;
function VariantToSafeUInt64(value: OleVariant): UInt64;
function VariantToSafeString(value: OleVariant): string;
function VariantToSafeDateTime(const value: OleVariant; const defaultValue: TDateTime = 0): TDateTime;

implementation

uses
  Variants,
  SysUtils;

function VariantToSafeUInt32(value: OleVariant): UInt32;
begin
  if VarIsNull(value) or VarIsEmpty(value)
  then
    Result := 0
  else
    Result := value;
end;

function VariantToSafeUInt64(value: OleVariant): UInt64;
begin
  if VarIsNull(value) or VarIsEmpty(value)
  then
    Result := 0
  else
    Result := value;
end;

function VariantToSafeString(value: OleVariant): string;
begin
  if VarIsNull(value) or VarIsEmpty(value)
  then
    Result := ''
  else
    Result := value;
end;

function VariantToSafeDateTime(const value: OleVariant; const defaultValue: TDateTime = 0): TDateTime;
begin
  if VarIsNull(value) or VarIsEmpty(value)
  then
    Result := defaultValue
  else
    try
      Result := VarToDateTime(value);
    except
      on e: Exception do
        Result := defaultValue;
    end;
end;

end.
