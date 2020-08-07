unit fApp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmApp = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    edtSendGridKey: TEdit;
    edtFrom: TEdit;
    Label2: TLabel;
    edtTo: TEdit;
    Label3: TLabel;
    edtCC: TEdit;
    Label4: TLabel;
    edtBCC: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    edtSubject: TEdit;
    Label7: TLabel;
    edtContentType: TEdit;
    Label8: TLabel;
    mmMessage: TMemo;
    Label9: TLabel;
    lbAttachFiles: TListBox;
    btnAdd: TButton;
    btnRemove: TButton;
    OpenDialog: TOpenDialog;
    edtNameFrom: TEdit;
    Label10: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmApp: TfrmApp;

implementation

{$R *.dfm}

uses
  Lib.Entidade.SendEmailToSendGrid
  , IniFiles;

procedure TfrmApp.Button1Click(Sender: TObject);
var
  i: integer;
begin

  with TIniFile.Create( ChangeFileExt( Application.ExeName, '.INI' ) ) do
  try

    WriteString( 'CONFIG', 'SENDGRIDKEY', edtSendGridKey.Text );
    WriteString( 'CONFIG', 'FROM'       , edtFrom.Text );
    WriteString( 'CONFIG', 'NAMEFROM'   , edtNameFrom.Text );
    WriteString( 'CONFIG', 'TO'         , edtTo.Text );
    WriteString( 'CONFIG', 'CC'         , edtCC.Text );
    WriteString( 'CONFIG', 'BCC'        , edtBCC.Text );
    WriteString( 'CONFIG', 'CONTENTTYPE', edtContentType.Text );

  finally
    Free;
  end;

  with TSendEmailToSendGrid
         .New(edtSendGridKey.Text)
           .SetFrom(edtFrom.Text)
           .SetNameFrom(edtNameFrom.Text)
           .AddTo(edtTo.Text)
           .AddCC(edtCC.Text)
           .AddBCC(edtBCC.Text)
           //.SetSubject(Format(FormatDateTime('"%s -" DD/MM/YYYY HH:NN:SS',Now),[edtSubject.Text]))
           .SetSubject(Format(FormatDateTime('"%s -" DD/MM/YYYY HH:NN:SS',Now),[edtSubject.Text]))
           .SetContentType(edtContentType.Text)
           .SetMessage(mmMessage.Lines.Text) do
  begin
    for i := 0 to lbAttachFiles.Items.Count-1 do
      AddAttachFile(lbAttachFiles.Items[i]);
    if SendEmail then
      ShowMessage('Email enviado')
    else
      ShowMessage('Email não enviado! '+ErrorMessage);
  end;
end;

procedure TfrmApp.FormShow(Sender: TObject);
begin

  with TIniFile.Create( ChangeFileExt( Application.ExeName, '.INI' ) ) do
  try

    edtSendGridKey.Text := ReadString( 'CONFIG', 'SENDGRIDKEY', '' );
    edtFrom.Text        := ReadString( 'CONFIG', 'FROM'       , '' );
    edtNameFrom.Text    := ReadString( 'CONFIG', 'NAMEFROM'   , '' );
    edtTo.Text          := ReadString( 'CONFIG', 'TO'         , '' );
    edtCC.Text          := ReadString( 'CONFIG', 'CC'         , '' );
    edtBCC.Text         := ReadString( 'CONFIG', 'BCC'        , '' );
    edtContentType.Text := ReadString( 'CONFIG', 'CONTENTTYPE', '' );

  finally
    Free;
  end;

end;

procedure TfrmApp.btnAddClick(Sender: TObject);
begin
  if OpenDialog.Execute and FileExists(OpenDialog.FileName) then
    lbAttachFiles.Items.Add(OpenDialog.FileName);
  btnRemove.Enabled:=lbAttachFiles.Count>0;
end;

procedure TfrmApp.btnRemoveClick(Sender: TObject);
const
  NO_ITEM_SELECTED = -1;
begin
  if lbAttachFiles.ItemIndex<>NO_ITEM_SELECTED then
    lbAttachFiles.Items.Delete(lbAttachFiles.ItemIndex)
  else
    ShowMessage('Escolha um arquivo a ser removido da lista');
  btnRemove.Enabled:=lbAttachFiles.Count>0;
end;

end.


