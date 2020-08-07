object frmApp: TfrmApp
  Left = 0
  Top = 0
  ActiveControl = Button1
  Caption = 'Teste SendGrid'
  ClientHeight = 619
  ClientWidth = 903
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  DesignSize = (
    903
    619)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 10
    Width = 64
    Height = 13
    Caption = 'SendGrid Key'
  end
  object Label2: TLabel
    Left = 8
    Top = 58
    Width = 24
    Height = 13
    Caption = 'From'
  end
  object Label3: TLabel
    Left = 8
    Top = 108
    Width = 12
    Height = 13
    Caption = 'To'
  end
  object Label4: TLabel
    Left = 455
    Top = 106
    Width = 14
    Height = 13
    Caption = 'CC'
  end
  object Label5: TLabel
    Left = 8
    Top = 162
    Width = 20
    Height = 13
    Caption = 'BCC'
  end
  object Label6: TLabel
    Left = 8
    Top = 218
    Width = 36
    Height = 13
    Caption = 'Subject'
  end
  object Label7: TLabel
    Left = 455
    Top = 162
    Width = 64
    Height = 13
    Caption = 'Content type'
  end
  object Label8: TLabel
    Left = 8
    Top = 264
    Width = 42
    Height = 13
    Caption = 'Message'
  end
  object Label9: TLabel
    Left = 455
    Top = 262
    Width = 59
    Height = 13
    Caption = 'Attach Files '
  end
  object Label10: TLabel
    Left = 455
    Top = 58
    Width = 54
    Height = 13
    Caption = 'Name From'
  end
  object Button1: TButton
    Left = 455
    Top = 27
    Width = 75
    Height = 25
    Caption = 'Enviar Email'
    TabOrder = 0
    OnClick = Button1Click
  end
  object edtSendGridKey: TEdit
    Left = 8
    Top = 29
    Width = 441
    Height = 21
    TabOrder = 1
  end
  object edtFrom: TEdit
    Left = 8
    Top = 77
    Width = 441
    Height = 21
    TabOrder = 2
  end
  object edtTo: TEdit
    Left = 8
    Top = 127
    Width = 441
    Height = 21
    TabOrder = 3
  end
  object edtCC: TEdit
    Left = 455
    Top = 127
    Width = 441
    Height = 21
    TabOrder = 4
  end
  object edtBCC: TEdit
    Left = 8
    Top = 181
    Width = 441
    Height = 21
    TabOrder = 5
  end
  object edtSubject: TEdit
    Left = 8
    Top = 237
    Width = 887
    Height = 21
    TabOrder = 6
    Text = 'Teste'
  end
  object edtContentType: TEdit
    Left = 455
    Top = 181
    Width = 441
    Height = 21
    TabOrder = 7
  end
  object mmMessage: TMemo
    Left = 8
    Top = 283
    Width = 441
    Height = 328
    Anchors = [akLeft, akTop, akBottom]
    Lines.Strings = (
      
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed in ' +
        'augue eros. Interdum et '
      
        'malesuada fames ac ante ipsum primis in faucibus. Aliquam luctus' +
        ' elit eu velit pulvinar '
      
        'egestas non in risus. Nunc nec risus massa. Class aptent taciti ' +
        'sociosqu ad litora torquent '
      
        'per conubia nostra, per inceptos himenaeos. Curabitur efficitur ' +
        'porta ultricies. Integer '
      
        'risus nibh, suscipit ut aliquam id, varius ut augue. Nunc posuer' +
        'e fermentum elit dapibus '
      
        'dapibus. Aenean vitae semper ipsum, pretium euismod elit. Nunc f' +
        'ermentum odio luctus '
      
        'enim euismod, ut tincidunt ipsum facilisis. Aenean a purus facil' +
        'isis, fermentum libero in, '
      
        'pulvinar lacus. Vestibulum ante ipsum primis in faucibus orci lu' +
        'ctus et ultrices posuere '
      'cubilia curae;'
      ''
      
        'Quisque quis tempor felis. Donec efficitur aliquam lacus. Class ' +
        'aptent taciti sociosqu ad '
      
        'litora torquent per conubia nostra, per inceptos himenaeos. Sed ' +
        'sit amet vulputate '
      
        'lectus, in pretium felis. Maecenas ultricies, ante sit amet tris' +
        'tique fringilla, velit nibh '
      
        'cursus tellus, ut volutpat nisl nisl ac ante. Maecenas a ipsum c' +
        'ondimentum, laoreet leo '
      
        'vitae, tincidunt massa. Morbi placerat tristique magna et condim' +
        'entum. Curabitur lobortis '
      
        'mattis egestas. Praesent consectetur vitae justo nec dictum. Mae' +
        'cenas purus diam, '
      
        'finibus a nisl ac, iaculis ullamcorper massa. Mauris dapibus con' +
        'dimentum imperdiet. Etiam '
      
        'at leo vestibulum, imperdiet turpis eget, consequat risus. Nulla' +
        ' semper arcu nec mauris '
      
        'auctor, vel vehicula velit feugiat. Donec aliquet libero enim, i' +
        'd accumsan ligula aliquet in. '
      'Praesent vitae nisl dui.'
      ''
      
        'Integer laoreet luctus ultricies. Proin pharetra justo vitae lib' +
        'ero dapibus, sit amet eleifend '
      
        'augue molestie. Ut vestibulum, elit vitae pellentesque imperdiet' +
        ', ex est ultrices risus, a '
      
        'pharetra dolor odio viverra risus. Pellentesque dui ante, dictum' +
        ' vulputate pretium ac, '
      
        'lobortis ornare elit. Nam at purus iaculis, viverra lacus vitae,' +
        ' aliquet libero. Curabitur eros '
      
        'ipsum, lacinia id diam non, iaculis tincidunt purus. Donec eu ma' +
        'uris quis orci interdum '
      'vestibulum nec eget purus.'
      ''
      
        'Pellentesque id tincidunt nibh. Nulla faucibus ornare neque et v' +
        'iverra. Mauris posuere '
      
        'ipsum leo, mattis ultrices velit laoreet vel. Duis non nunc pell' +
        'entesque, efficitur urna nec, '
      
        'interdum diam. Aenean eget egestas metus. Proin dui velit, facil' +
        'isis dapibus finibus at, '
      
        'volutpat in enim. Vestibulum ante ipsum primis in faucibus orci ' +
        'luctus et ultrices posuere '
      
        'cubilia curae; Nulla euismod purus auctor est tincidunt, in vene' +
        'natis dolor faucibus.'
      ''
      
        'Donec dolor mauris, sodales sed augue vitae, efficitur malesuada' +
        ' ipsum. Aenean sit amet '
      
        'tincidunt ex. Vestibulum commodo rutrum mi, id sagittis sem laci' +
        'nia lobortis. Sed '
      
        'fermentum, sapien at interdum tempus, nulla neque ultrices mauri' +
        's, ac suscipit justo urna '
      
        'eu massa. Vivamus non pulvinar risus, eu sagittis felis. Praesen' +
        't vitae nisl metus. Etiam '
      
        'non tempor erat, ut lacinia neque. Nam ornare congue arcu auctor' +
        ' molestie. In congue '
      
        'ultricies lacus, id facilisis sapien ultricies vel. Vestibulum s' +
        'ed arcu sit amet leo fermentum '
      
        'euismod ut quis massa. Duis orci sem, pulvinar nec euismod aucto' +
        'r, lacinia non arcu. '
      
        'Donec blandit molestie dolor, non accumsan risus lacinia id. Int' +
        'eger sagittis vel quam '
      'hendrerit scelerisque. Aliquam erat volutpat.')
    TabOrder = 8
  end
  object lbAttachFiles: TListBox
    Left = 455
    Top = 283
    Width = 440
    Height = 328
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 9
  end
  object btnAdd: TButton
    Left = 739
    Top = 262
    Width = 75
    Height = 19
    Anchors = [akTop, akRight]
    Caption = 'Add'
    TabOrder = 10
    OnClick = btnAddClick
  end
  object btnRemove: TButton
    Left = 820
    Top = 262
    Width = 75
    Height = 19
    Anchors = [akTop, akRight]
    Caption = 'Remove'
    TabOrder = 11
    OnClick = btnRemoveClick
  end
  object edtNameFrom: TEdit
    Left = 455
    Top = 77
    Width = 441
    Height = 21
    TabOrder = 12
  end
  object OpenDialog: TOpenDialog
    Left = 728
    Top = 16
  end
end
