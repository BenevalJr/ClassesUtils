unit Lib.Entidade.SendFileBase64ToAWSS3;

interface

uses
  Data.Cloud.AmazonAPI;

type
  ISendFileBase64ToAWSS3 = interface
    ['{60C10930-6EBA-446A-83F4-8CF5BEA4BBE0}']
    function SetAccountName( const aAccountName: string ): ISendFileBase64ToAWSS3;
    function SetAccountKey( const aAccountKey: string ): ISendFileBase64ToAWSS3;
    function SetFileContentBase64( const aFileContentBase64: string ): ISendFileBase64ToAWSS3;
    function SetFileName( const aFileName: string ): ISendFileBase64ToAWSS3;
    function SetBucketName( const aBucketName: string ): ISendFileBase64ToAWSS3;
    function SetRegionAWS( const aRegionAWS: TAmazonRegion ): ISendFileBase64ToAWSS3;
    function SendFile: boolean;
  end;

  TSendFileBase64ToAWSS3 = class(TInterfacedObject, ISendFileBase64ToAWSS3)
  private
    { private declarations }
    FAccountName: string;
    FAccountKey: string;
    FBucketName: string;
    FFileContentBase64: string;
    FFileName: string;
    FRegionAWS: TAmazonRegion;
  public
    { public declarations }
    class function New: ISendFileBase64ToAWSS3;
    constructor Create;
    destructor Destroy; override;

    function SetAccountName( const aAccountName: string ): ISendFileBase64ToAWSS3;
    function SetAccountKey( const aAccountKey: string ): ISendFileBase64ToAWSS3;
    function SetFileContentBase64( const aFileContentBase64: string ): ISendFileBase64ToAWSS3;
    function SetFileName( const aFileName: string ): ISendFileBase64ToAWSS3;
    function SetBucketName( const aBucketName: string ): ISendFileBase64ToAWSS3;
    function SetRegionAWS( const aRegionAWS: TAmazonRegion ): ISendFileBase64ToAWSS3;
    function SendFile: boolean;
  end;

implementation

uses
  System.Classes, Data.Cloud.CloudAPI, System.SysUtils,
  System.RegularExpressions, System.NetEncoding, MyFunctionsUtils;

class function TSendFileBase64ToAWSS3.New: ISendFileBase64ToAWSS3;
begin
  Result := Self.Create;
end;

constructor TSendFileBase64ToAWSS3.Create;
begin
end;

destructor TSendFileBase64ToAWSS3.Destroy;
begin

  inherited;
end;

function TSendFileBase64ToAWSS3.SendFile: boolean;
var
  LInput: TStringStream;
  LOutput: TMemoryStream;
  lContentType: string;

  lMeta                : TStringList;
  lHeader              : TStringList;
  lResponse            : TCloudResponseInfo;
  lAWSConnectionInfo   : TAmazonConnectionInfo;
  lS3                  : TAmazonStorageService;
  //lS3Region            : TAmazonRegion;
  //lRegion              : string;

  lFileContent         : TBytes;
  lReader              : TBinaryReader;

begin

  with TRegEx.Create('data\:(.*)\;base64\,(.*)',[]).Match( FFileContentBase64 ) do
    if Success then
    begin
      lContentType      :=Groups.Item[1].Value;
      FFileContentBase64:=Groups.Item[2].Value;
    end;

  LInput := TStringStream.Create(FFileContentBase64);
  LOutput := TMemoryStream.Create;

  lMeta                := TStringList.Create;
  lResponse            := TCloudResponseInfo.Create;
  lHeader              := TStringList.Create;
  lAWSConnectionInfo   := TAmazonConnectionInfo.Create(Nil);

  lAWSConnectionInfo.UseDefaultEndpoints:=False;
  lAWSConnectionInfo.Region             :=FRegionAWS;
  lAWSConnectionInfo.AccountName        :=FAccountName;
  lAWSConnectionInfo.AccountKey         :=FAccountKey;


  lS3                  := TAmazonStorageService.Create(lAWSConnectionInfo);
  //lRegion              := TAmazonStorageService.GetRegionString(lS3Region);

  try

    LInput.Position := 0;
    TNetEncoding.Base64.Decode( LInput, LOutput );
    LOutput.Position := 0;
    //LOutput.SaveToFile( aFileName );

    lReader := TBinaryReader.Create( LOutput );
    try
      lFileContent := lReader.ReadBytes(lReader.BaseStream.Size);
    finally
      lReader.Free;
    end;

    lMeta.Values['Content-Type']  :=lContentType;
    lHeader.Values['Content-Type']:=lContentType;

    try
      Result:=lS3.UploadObject( FBucketName,
                                FFileName,
                                lFileContent,
                                False,
                                lMeta,
                                lHeader,
                                amzbaPublicReadWrite,
                                lResponse );
    except
      on E: Exception do
      begin
        Result:=False;
        TMyLog.SaveLog(E.Message);
      end;

    end;

  finally
    lMeta.Free;
    lResponse.Free;
    lHeader.Free;
    lAWSConnectionInfo.Free;
    lS3.Free;

  end;

end;

function TSendFileBase64ToAWSS3.SetAccountKey(
  const aAccountKey: string): ISendFileBase64ToAWSS3;
begin
  Result:=Self;
  FAccountKey:=aAccountKey;
end;

function TSendFileBase64ToAWSS3.SetAccountName(
  const aAccountName: string): ISendFileBase64ToAWSS3;
begin
  Result:=Self;
  FAccountName:=aAccountName;
end;

function TSendFileBase64ToAWSS3.SetBucketName(
  const aBucketName: string): ISendFileBase64ToAWSS3;
begin
  Result:=Self;
  FBucketName:=aBucketName;
end;

function TSendFileBase64ToAWSS3.SetFileContentBase64(
  const aFileContentBase64: string): ISendFileBase64ToAWSS3;
begin
  Result:=Self;
  FFileContentBase64:=aFileContentBase64;
end;

function TSendFileBase64ToAWSS3.SetFileName(
  const aFileName: string): ISendFileBase64ToAWSS3;
begin
  Result:=Self;
  FFileName:=aFileName;
end;

function TSendFileBase64ToAWSS3.SetRegionAWS( const aRegionAWS: TAmazonRegion ): ISendFileBase64ToAWSS3;
begin
  Result:=Self;
  FRegionAWS:=aRegionAWS;
end;

end.
