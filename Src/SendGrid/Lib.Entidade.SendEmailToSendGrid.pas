unit Lib.Entidade.SendEmailToSendGrid;

interface

uses
  System.SysUtils
  , System.JSON
  , System.Classes;

type
  ISendEmailToSendGrid = interface
    ['{8057B68A-A855-48DD-9198-F6E1EBB0E415}']
    function SetFrom( const aFrom: string ): ISendEmailToSendGrid;
    function SetNameFrom( const aNameFrom: string ): ISendEmailToSendGrid;
    function AddTo( const aEmailTo: string ): ISendEmailToSendGrid;
    function AddCC( const aEmailCC: string ): ISendEmailToSendGrid;
    function AddBCC( const aEmailBCC: string ): ISendEmailToSendGrid;
    function AddAttachFile( const aAttachFile: TFileName ): ISendEmailToSendGrid;
    function SetSubject( const aSubject: string ): ISendEmailToSendGrid;
    function SetContentType( const aContentType: string ): ISendEmailToSendGrid;
    function SetMessage( const aMessage: string ): ISendEmailToSendGrid;
    function ErrorMessage: string;
    function SendEmail: boolean;
  end;

  TSendEmailToSendGrid = class(TInterfacedObject, ISendEmailToSendGrid)
  private
    { private declarations }
    FFrom: string;
    FNameFrom: string;
    FEmailTo: TStrings;
    FEmailCC: TStrings;
    FEmailBCC: TStrings;
    FAttachFile: TStrings;
    FSubject: string;
    FContentType: string;
    FMessage: string;
    FSendGridKey: string;
    FErrorMessage: string;

    procedure AddEmailIn( aListEmail: TStrings; const aEmailTo: string );
    function GetBodyRequestSendGrid: TJSONObject;
    function RequestToSendGrid( aBodyContent: TJSONObject ): boolean;
    function LoadBase64File(const aFileName: TFileName): string;
  public
    { public declarations }
    class function New( aSendGridKey: string ): ISendEmailToSendGrid;
    constructor Create( aSendGridKey: string );
    destructor Destroy; override;

    function SetFrom( const aFrom: string ): ISendEmailToSendGrid;
    function SetNameFrom( const aNameFrom: string ): ISendEmailToSendGrid;
    function AddTo( const aEmailTo: string ): ISendEmailToSendGrid;
    function AddCC( const aEmailCC: string ): ISendEmailToSendGrid;
    function AddBCC( const aEmailBCC: string ): ISendEmailToSendGrid;
    function AddAttachFile( const aAttachFile: TFileName ): ISendEmailToSendGrid;
    function SetSubject( const aSubject: string ): ISendEmailToSendGrid;
    function SetContentType( const aContentType: string ): ISendEmailToSendGrid;
    function SetMessage( const aMessage: string ): ISendEmailToSendGrid;
    function ErrorMessage: string;
    function SendEmail: boolean;
  end;

implementation

uses
  System.IOUtils
  , System.NetEncoding
  , REST.Client
  , REST.Types
  ;

class function TSendEmailToSendGrid.New( aSendGridKey: string ): ISendEmailToSendGrid;
begin
  Result := Self.Create( aSendGridKey );
end;

constructor TSendEmailToSendGrid.Create( aSendGridKey: string );
begin
  FEmailTo:=TStringList.Create;
  FEmailCC:=TStringList.Create;
  FEmailBCC:=TStringList.Create;
  FAttachFile:=TStringList.Create;
  FContentType:='text/plain';
  FSendGridKey:=aSendGridKey;
end;

destructor TSendEmailToSendGrid.Destroy;
begin
  FreeAndNil(FAttachFile);
  FreeAndNil(FEmailBCC);
  FreeAndNil(FEmailCC);
  FreeAndNil(FEmailTo);
  inherited;
end;

function TSendEmailToSendGrid.AddAttachFile(
  const aAttachFile: TFileName): ISendEmailToSendGrid;
begin
  Result:=Self;
  if FAttachFile.IndexOf(aAttachFile)=-1 then
    FAttachFile.Add(aAttachFile)
end;

function TSendEmailToSendGrid.AddBCC(
  const aEmailBCC: string): ISendEmailToSendGrid;
begin
  Result:=Self;
  AddEmailIn( FEmailBCC, aEmailBCC );
end;

function TSendEmailToSendGrid.AddCC(const aEmailCC: string): ISendEmailToSendGrid;
begin
  Result:=Self;
  AddEmailIn( FEmailCC, aEmailCC );
end;

procedure TSendEmailToSendGrid.AddEmailIn(aListEmail: TStrings;
  const aEmailTo: string);
begin
  if ( FEmailTo.IndexOf(aEmailTo)=-1 ) and ( FEmailCC.IndexOf(aEmailTo)=-1 ) and ( FEmailBCC.IndexOf(aEmailTo)=-1 ) then
    aListEmail.Add( aEmailTo );
end;

function TSendEmailToSendGrid.AddTo(const aEmailTo: string): ISendEmailToSendGrid;
begin
  Result:=Self;
  AddEmailIn( FEmailTo, aEmailTo );
end;

function TSendEmailToSendGrid.SendEmail: boolean;
var
  lBodyContent: TJSONObject;
begin

  try

    if FEmailTo.Count=0 then
      Exception.Create('Email To não informado')
    else if FFrom=EmptyStr then
      Exception.Create('Email From não informado')
    else if FMessage=EmptyStr then
      Exception.Create('Mensagem não informada')
    else if FSubject=EmptyStr then
      Exception.Create('Assunto não informada');

    lBodyContent:=GetBodyRequestSendGrid;
    try
      if RequestToSendGrid( lBodyContent ) then
        Result:=True
      else
        Result:=False;
    finally
      FreeAndNil(lBodyContent);
    end;

  except
    on E:Exception do
    begin
      Result:=False;
      FErrorMessage:=E.Message;
    end;

  end;

end;

function TSendEmailToSendGrid.GetBodyRequestSendGrid: TJSONObject; 
var
  lFrom: TJSONObject;
  lContent, lAttachments, lTo, lCC, lBCC: TJSONArray;
  lArrayPersonalizations: TJSONArray;
  lPersonalizations: TJSONPair;
  i: integer;

  procedure AddEmailsInArray( aJSONArray: TJSONArray; aListEmails: TStrings );
  var
    i: Integer;
  begin
    for i := 0 to aListEmails.Count-1 do
      aJSONArray.AddElement(TJSONObject.Create.AddPair('email',aListEmails[i]));
  end;

begin

  Result:=TJSONObject.Create;

  lAttachments:=TJSONArray.Create;
  lContent:=TJSONArray.Create;
  lTo:=TJSONArray.Create;
  lCC:=TJSONArray.Create;
  lBCC:=TJSONArray.Create;
  lFrom:=TJSONObject.Create;
  lArrayPersonalizations:=TJSONArray.Create;
  lPersonalizations:=TJSONPair.Create('personalizations',lArrayPersonalizations);

  //try

    AddEmailsInArray(lTo,FEmailTo);
    AddEmailsInArray(lCC,FEmailCC);
    AddEmailsInArray(lBCC,FEmailBCC);

    lFrom.AddPair('email',FFrom);
    if FNameFrom<>EmptyStr then
      lFrom.AddPair('name',FNameFrom);

    lContent.AddElement( TJSONObject.Create
                           .AddPair('type',FContentType)
                           .AddPair('value',FMessage) );

    lArrayPersonalizations
      .AddElement( TJSONObject.Create
                     .AddPair( 'to' , lTo )
                     .AddPair( 'cc' , lCC )
                     .AddPair( 'bcc' , lBCC )
                 );

    for i := 0 to FAttachFile.Count-1 do
      lAttachments.AddElement( TJSONObject.Create
                                 .AddPair('content',LoadBase64File(FAttachFile[i]))
                                 .AddPair('filename',ExtractFileName(FAttachFile[i])) );

    Result
      .AddPair( lPersonalizations )
      .AddPair( 'from',    lFrom )
      .AddPair( 'subject', FSubject )
      .AddPair( 'content', lContent );

    if FAttachFile.Count>0 then
      Result.AddPair( 'attachments', lAttachments );

  //finally

    {if Assigned(lBCC) then
      FreeAndNil(lBCC);
    if Assigned(lCC) then
      FreeAndNil(lCC);
    if Assigned(lTo) then
      FreeAndNil(lTo);
    if Assigned(lFrom) then
      FreeAndNil(lFrom);
    if Assigned(lContent) then
      FreeAndNil(lContent);
    if Assigned(lArrayPersonalizations) then
      FreeAndNil(lArrayPersonalizations);
    if Assigned(lPersonalizations) then
      FreeAndNil(lPersonalizations);}

  //end;

end;

function TSendEmailToSendGrid.SetContentType(
  const aContentType: string): ISendEmailToSendGrid;
begin
  Result:=Self;
  FContentType:=aContentType;
end;

function TSendEmailToSendGrid.SetFrom(const aFrom: string): ISendEmailToSendGrid;
begin
  Result:=Self;
  FFrom:=aFrom;
end;

function TSendEmailToSendGrid.SetMessage(
  const aMessage: string): ISendEmailToSendGrid;
begin
  Result:=Self;
  FMessage:=aMessage;
end;

function TSendEmailToSendGrid.SetNameFrom(
  const aNameFrom: string): ISendEmailToSendGrid;
begin
  Result:=Self;
  FNameFrom:=aNameFrom;
end;

function TSendEmailToSendGrid.SetSubject(
  const aSubject: string): ISendEmailToSendGrid;
begin
  Result:=Self;
  FSubject:=aSubject;
end;

function TSendEmailToSendGrid.ErrorMessage: string;
begin
  Result:=FErrorMessage;
end;

function TSendEmailToSendGrid.RequestToSendGrid( aBodyContent: TJSONObject ): boolean;
var
  lRESTClient: TRESTClient;
  lRESTResponse: TRESTResponse;
  lRESTRequest: TRESTRequest;
begin

  lRESTClient:=TRESTClient.Create('https://api.sendgrid.com/v3/mail/send');
  lRESTResponse:=TRESTResponse.Create(Nil);
  lRESTRequest:=TRESTRequest.Create(Nil);

  try
    lRESTClient.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
    lRESTClient.AcceptCharset := 'utf-8, *;q=0.8';

    lRESTRequest.Client := lRESTClient;
    lRESTRequest.Method := rmPOST;
    lRESTRequest.Response := lRESTResponse;
    lRESTRequest.Params.AddHeader('Authorization',Format('Bearer %s',[FSendGridKey])).Options:=[poDoNotEncode];
    lRESTRequest.Params.AddHeader('Content-Type','application/json').Options:=[poDoNotEncode];
    lRESTRequest.Params.AddHeader('Accept','application/json').Options:=[poDoNotEncode];
    lRESTRequest.Params.AddBody(aBodyContent);
    lRESTRequest.Execute;

    Result:=lRESTResponse.StatusCode in [200,202];

    if not Result then
      FErrorMessage:=lRESTResponse.ErrorMessage;

  finally
    FreeAndNil(lRESTRequest);
    FreeAndNil(lRESTResponse);
    FreeAndNil(lRESTClient);
  end;

end;

function TSendEmailToSendGrid.LoadBase64File( const aFileName: TFileName): string;
var
  LInput : TMemoryStream;
  LOutput: TMemoryStream;
  lStringOutput: string;
begin
  LInput := TMemoryStream.Create;
  LOutput := TMemoryStream.Create;
  try
    LInput.LoadFromFile(aFileName);
    LInput.Position := 0;
    TNetEncoding.Base64.Encode( LInput, LOutput );
    LOutput.Position := 0;
    SetString(lStringOutput, PAnsiChar(LOutput.Memory), LOutput.Size);
    Result:=AnsiString( lStringOutput );
  finally
    LInput.Free;
    LOutput.Free;
  end;
end;

end.
