unit ufrmCadPontoUnidade;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniGUIBaseClasses, uniPanel, uniLabel, uniEdit,
  uniMultiItem, uniComboBox, uniButton, uniBitBtn, uniBasicGrid, uniDBGrid,  Vcl.Dialogs;

type
  TfrmCadPontoUnidade = class(TUniForm)
    UniPanel1: TUniPanel;
    UniPanel2: TUniPanel;
    UniLabel1: TUniLabel;
    UniLabel2: TUniLabel;
    UniLabel3: TUniLabel;
    UniLabel4: TUniLabel;
    UniLabel5: TUniLabel;
    UniLabel6: TUniLabel;
    UniLabel7: TUniLabel;
    UniLabel8: TUniLabel;
    UniLabel9: TUniLabel;
    UniLabel10: TUniLabel;
    edtPonto: TUniEdit;
    UniLabel11: TUniLabel;
    UniPanel3: TUniPanel;
    edtUnidade: TUniEdit;
    edtCEP: TUniEdit;
    edtCNPJ: TUniEdit;
    edtBairro: TUniEdit;
    edtRua: TUniEdit;
    edtNumero: TUniEdit;
    edtCidade: TUniEdit;
    cmbUF: TUniComboBox;
    edtPontoRef: TUniEdit;
    btnCadastrar: TUniBitBtn;
    btnEditar: TUniBitBtn;
    btnExcluir: TUniBitBtn;
    btnPesquisar: TUniBitBtn;
    btnVoltar: TUniBitBtn;
    btnSair: TUniBitBtn;
    UniDBGrid1: TUniDBGrid;
    UniPanel5: TUniPanel;
    UniPanel6: TUniPanel;
    UniPanel7: TUniPanel;
    UniPanel8: TUniPanel;
    UniPanel9: TUniPanel;
    UniPanel10: TUniPanel;
    UniPanel11: TUniPanel;
    UniPanel12: TUniPanel;
    UniPanel4: TUniPanel;
    UniLabel12: TUniLabel;
    UniDBGrid2: TUniDBGrid;
    procedure btnSairClick(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure edtUnidadeKeyPress(Sender: TObject; var Key: Char);
    procedure edtPontoKeyPress(Sender: TObject; var Key: Char);
    procedure edtCEPKeyPress(Sender: TObject; var Key: Char);
    procedure edtCNPJKeyPress(Sender: TObject; var Key: Char);
    procedure edtRuaKeyPress(Sender: TObject; var Key: Char);
    procedure edtBairroKeyPress(Sender: TObject; var Key: Char);
    procedure edtNumeroKeyPress(Sender: TObject; var Key: Char);
    procedure edtCidadeKeyPress(Sender: TObject; var Key: Char);
    procedure edtCidadeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cmbUFKeyPress(Sender: TObject; var Key: Char);
    procedure edtPontoRefKeyPress(Sender: TObject; var Key: Char);
    procedure edtUnidadeExit(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure UniDBGrid1CellClick(Column: TUniDBGridColumn);
    procedure btnCadastrarClick(Sender: TObject);
    procedure edtCNPJExit(Sender: TObject);
    procedure edtNumeroKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
  private
    { Private declarations }
    EventoOnExit: Boolean; // nova variável
  public
    { Public declarations }

    sSelect,sInsert,sUpdate,sDelete,sCnpj,sCep,sRua,sBairro,sCidade,sUF,sPontoRef: String;

    sUnidade,sPonto,sNumero: Integer;
  end;

function frmCadPontoUnidade: TfrmCadPontoUnidade;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication, ufuncoes;

function frmCadPontoUnidade: TfrmCadPontoUnidade;
begin
  Result := TfrmCadPontoUnidade(UniMainModule.GetFormInstance(TfrmCadPontoUnidade));
end;

function LimparCNPJ(const cnpj: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(cnpj) do
  begin
    if cnpj[i] in ['0'..'9'] then
      Result := Result + cnpj[i];
  end;
end;

procedure TfrmCadPontoUnidade.btnCadastrarClick(Sender: TObject);
begin
  if (AllTrim(edtUnidade.Text) = '') then
  begin
    ShowMessage('Para cadastrar uma loja informe o código da unidade!');
    edtUnidade.SetFocus;
    exit;
  end;

  if (AllTrim(edtPonto.Text) = '') then
  begin
    ShowMessage('Para cadastrar uma loja informe a qual ponto ela vai pertencer no campo de código do ponto');
    edtPonto.SetFocus;
    exit;
  end;

  sUnidade := StrToInt(AllTrim(edtUnidade.Text));
  sPonto := StrToInt(AllTrim(edtPonto.Text));

  UniMainModule.qryCadastroPontoUnidade.Active := False;
  UniMainModule.qryCadastroPontoUnidade.SQL.Clear;

  sSelect := ' select * from GRZ_LOC_ENDERECO_PONTOS' +
             ' where cod_unidade = :sUnidade '+
             ' and cod_ponto = :sPonto ';

  UniMainModule.qryCadastroPontoUnidade.SQL.Add(sSelect);

  UniMainModule.qryCadastroPontoUnidade.ParamByName('sUnidade').AsInteger := sUnidade;
  UniMainModule.qryCadastroPontoUnidade.ParamByName('sPonto').AsInteger := sPonto;

  UniMainModule.qryCadastroPontoUnidade.Active := True;

  if UniMainModule.qryCadastroPontoUnidade.RecordCount > 0 then
  begin
    ShowMessage('A unidade que voçe está tentando cadastrar já existe no ponto '+IntToStr(sPonto)+'.Informe um número de ponto diferente para essa unidade');
    edtUnidade.SetFocus;
    exit;
  end;

  sCep := StringReplace(AllTrim(edtCEP.Text),'-','',[rfReplaceAll]);
  sCnpj := LimparCNPJ(AllTrim(edtCNPJ.Text));
  sRua := edtRua.Text;
  sBairro := edtBairro.Text;
  sNumero := StrToInt(AllTrim(edtNumero.Text));
  sCidade := edtCidade.Text;
  sUF := cmbUF.Text;
  sPontoRef := edtPontoRef.Text;

  UniMainModule.qryCadastroPontoUnidade.Active := False;
  UniMainModule.qryCadastroPontoUnidade.SQL.Clear;

  sInsert := 'INSERT INTO GRZ_LOC_ENDERECO_PONTOS ' +
             '(NUM_CEP, ' +
             'DES_BAIRRO, ' +
             'DES_RUA, ' +
             'DES_NUMERO, ' +
             'DES_CIDADE, ' +
             'DES_UF, ' +
             'DES_PONTO_REF, ' +
             'NUM_CNPJ) ' +
             'VALUES ' +
             '(:sCep, ' +
             ':sBairro, ' +
             ':sRua, ' +
             ':sNumero, ' +
             ':sCidade, ' +
             ':sUF, ' +
             ':sPontoRef, ' +
             ':sCnpj)';

  UniMainModule.qryCadastroPontoUnidade.SQL.Add(sInsert);
  UniMainModule.qryCadastroPontoUnidade.ParamByName('sCep').AsInteger := StrToInt(StringReplace(AllTrim(edtCEP.Text), '-', '', [rfReplaceAll]));
  UniMainModule.qryCadastroPontoUnidade.ParamByName('sBairro').AsString := edtBairro.Text;
  UniMainModule.qryCadastroPontoUnidade.ParamByName('sRua').AsString := edtRua.Text;
  UniMainModule.qryCadastroPontoUnidade.ParamByName('sNumero').AsInteger := StrToInt(AllTrim(edtNumero.Text));
  UniMainModule.qryCadastroPontoUnidade.ParamByName('sCidade').AsString := edtCidade.Text;
  UniMainModule.qryCadastroPontoUnidade.ParamByName('sUF').AsString := AllTrim(cmbUF.Text);
  UniMainModule.qryCadastroPontoUnidade.ParamByName('sPontoRef').AsString := edtPontoRef.Text;
  UniMainModule.qryCadastroPontoUnidade.ParamByName('sCnpj').AsInteger := StrToInt64(LimparCNPJ(AllTrim(edtCNPJ.Text)));
  UniMainModule.qryCadastroPontoUnidade.ExecSQL;

  UniMainModule.qryCadastroPontoUnidade.Active := False;
  UniMainModule.qryCadastroPontoUnidade.SQL.Clear;

  sInsert := ' insert into GRZ_LOC_PONTOS_UNIDADES '+
             ' (COD_PONTO, '+
             ' COD_UNIDADE) '+
             ' values '+
             ' (:Ponto, '+
             ' :sUnidade) ';

  UniMainModule.qryCadastroPontoUnidade.SQL.Add(sInsert);

  UniMainModule.qryCadastroPontoUnidade.ParamByName('sPonto').AsInteger := sPonto;
  UniMainModule.qryCadastroPontoUnidade.ParamByName('sUnidade').AsInteger := sUnidade;
  UniMainModule.qryCadastroPontoUnidade.ExecSQL;

  ShowMessage('Dados Gravados');

  btnVoltarClick(Sender);

end;

procedure TfrmCadPontoUnidade.btnEditarClick(Sender: TObject);
begin

  sUnidade := StrToInt(AllTrim(edtUnidade.Text));
  sPonto := StrToInt(AllTrim(edtPonto.Text));
  sCep := StringReplace(AllTrim(edtCEP.Text),'-','',[rfReplaceAll]);
  sCnpj := LimparCNPJ(AllTrim(edtCNPJ.Text));
  sRua := edtRua.Text;
  sBairro := edtBairro.Text;
  sNumero := StrToInt(AllTrim(edtNumero.Text));
  sCidade := edtCidade.Text;
  sUF := cmbUF.Text;
  sPontoRef := edtPontoRef.Text;

    UniMainModule.qryCadastroPontoUnidade.Active := False;
    UniMainModule.qryCadastroPontoUnidade.SQL.Clear;

    sSelect := ' select * from GRZ_LOC_ENDERECO_PONTOS '+
               ' where cod_unidade = :sUnidade ';

    UniMainModule.qryCadastroPontoUnidade.SQL.Add(sSelect);
    UniMainModule.qryCadastroPontoUnidade.ParamByName('sUnidade').AsInteger := sUnidade;
    UniMainModule.qryCadastroPontoUnidade.Active := True;

    if UniMainModule.qryCadastroPontoUnidade.RecordCount = 0 then
    begin
      ShowMessage('A loja ainda não foi cadastrada');
      edtUnidade.SetFocus;
      exit
    end
    else
    begin
      UniMainModule.qryCadastroPontoUnidade.Active := False;
      UniMainModule.qryCadastroPontoUnidade.SQL.Clear;

      sUpdate := 'UPDATE GRZ_LOC_ENDERECO_PONTOS'+
                 ' SET'+
                 ' COD_UNIDADE = :sUnidade,'+
                 ' NUM_CEP = :sCep,'+
                 ' DES_BAIRRO = :sBairro,'+
                 ' DES_RUA = :sRua,'+
                 ' DES_NUMERO = :sNumero,'+
                 ' DES_CIDADE = :sCidade,'+
                 ' DES_UF = :sUF,'+
                 ' DES_PONTO_REF = :sPontoRef,'+
                 ' NUM_CNPJ = :sCnpj'+
                 ' WHERE COD_PONTO = :sCodPonto '+
                 ' AND COD_UNIDADE = :sUnidade';

      UniMainModule.qryCadastroPontoUnidade.SQL.Add(sUpdate);

      UniMainModule.qryCadastroPontoUnidade.ParamByName('sCodPonto').AsInteger := sPonto;
      UniMainModule.qryCadastroPontoUnidade.ParamByName('sUnidade').AsInteger := sUnidade;
      UniMainModule.qryCadastroPontoUnidade.ParamByName('sCep').AsInteger := StrToInt(StringReplace(AllTrim(edtCEP.Text), '-', '', [rfReplaceAll]));
      UniMainModule.qryCadastroPontoUnidade.ParamByName('sBairro').AsString := edtBairro.Text;
      UniMainModule.qryCadastroPontoUnidade.ParamByName('sRua').AsString := edtRua.Text;
      UniMainModule.qryCadastroPontoUnidade.ParamByName('sNumero').AsInteger := StrToInt(AllTrim(edtNumero.Text));
      UniMainModule.qryCadastroPontoUnidade.ParamByName('sCidade').AsString := edtCidade.Text;
      UniMainModule.qryCadastroPontoUnidade.ParamByName('sUF').AsString := AllTrim(cmbUF.Text);
      UniMainModule.qryCadastroPontoUnidade.ParamByName('sPontoRef').AsString := edtPontoRef.Text;
      UniMainModule.qryCadastroPontoUnidade.ParamByName('sCnpj').AsInteger := StrToInt64(LimparCNPJ(AllTrim(edtCNPJ.Text)));

      UniMainModule.qryCadastroPontoUnidade.ExecSQL;
      ShowMessage('Dados Atualizados');

       UniMainModule.qryCadastroPontoUnidade.Active := False;
        UniMainModule.qryCadastroPontoUnidade.SQL.Clear;

        sSelect := ' select * from GRZ_LOC_ENDERECO_PONTOS '+
                   ' where cod_unidade = :sUnidade ';

        UniMainModule.qryCadastroPontoUnidade.SQL.Add(sSelect);
        UniMainModule.qryCadastroPontoUnidade.ParamByName('sUnidade').AsInteger := sUnidade;
        UniMainModule.qryCadastroPontoUnidade.Active := True;

    end;


end;

procedure TfrmCadPontoUnidade.btnExcluirClick(Sender: TObject);
begin
  sUnidade := StrToInt(AllTrim(edtUnidade.Text));
  sPonto := StrToInt(AllTrim(edtPonto.Text));
  sCep := StringReplace(AllTrim(edtCEP.Text),'-','',[rfReplaceAll]);
  sCnpj := LimparCNPJ(AllTrim(edtCNPJ.Text));
  sRua := edtRua.Text;
  sBairro := edtBairro.Text;
  sNumero := StrToInt(AllTrim(edtNumero.Text));
  sCidade := edtCidade.Text;
  sUF := cmbUF.Text;
  sPontoRef := edtPontoRef.Text;

    UniMainModule.qryCadastroPontoUnidade.Active := False;
    UniMainModule.qryCadastroPontoUnidade.SQL.Clear;

    sSelect := ' select * from GRZ_LOC_ENDERECO_PONTOS '+
               ' where cod_unidade = :sUnidade ';

    UniMainModule.qryCadastroPontoUnidade.SQL.Add(sSelect);
    UniMainModule.qryCadastroPontoUnidade.ParamByName('sUnidade').AsInteger := sUnidade;
    UniMainModule.qryCadastroPontoUnidade.Active := True;

    if UniMainModule.qryCadastroPontoUnidade.RecordCount = 0 then
    begin
      ShowMessage('A loja ainda não foi cadastrada');
      edtUnidade.SetFocus;
      exit
    end
    else
    begin
      if MessageDlg('Tem certeza que deseja excluir o registro?', mtConfirmation, mbYesNo) = mrYes then
        begin
          UniMainModule.qryCadastroPontoUnidade.Active := False;
          UniMainModule.qryCadastroPontoUnidade.SQL.Clear;

          sDelete := ' delete from GRZ_LOC_PONTOS_UNIDADES '+
                     ' where cod_unidade = :sUnidade '+
                     ' and cod_ponto = :sPonto ';

          UniMainModule.qryCadastroPontoUnidade.SQL.Add(sDelete);

          UniMainModule.qryCadastroPontoUnidade.ParamByName('sUnidade').AsInteger := sUnidade;
          UniMainModule.qryCadastroPontoUnidade.ParamByName('sPonto').AsInteger := sPonto;

          UniMainModule.qryCadastroPontoUnidade.ExecSQL;

          UniMainModule.qryCadastroPontoUnidade.Active := False;
          UniMainModule.qryCadastroPontoUnidade.SQL.Clear;

          sSelect := ' select * from GRZ_LOC_PONTOS_UNIDADES '+
                     ' where cod_ponto = :sPonto ';

          UniMainModule.qryCadastroPontoUnidade.SQL.Add(sSelect);
          UniMainModule.qryCadastroPontoUnidade.ParamByName('sPonto').AsInteger := sPonto;
          UniMainModule.qryCadastroPontoUnidade.Active := True;

          if UniMainModule.qryCadastroPontoUnidade.RecordCount = 0 then
          begin
             UniMainModule.qryCadastroPontoUnidade.Active := False;
             UniMainModule.qryCadastroPontoUnidade.SQL.Clear;

             sDelete := ' delete from GRZ_LOC_ENDERECO_PONTOS a '+
                        '             GRZ_LOC_PONTOS_UNIDADES b '+
                        ' where a.cod_ponto = b.cod_ponto '+
                        ' and a.cod_ponto = :sPonto ';

             UniMainModule.qryCadastroPontoUnidade.SQL.Add(sDelete);
             UniMainModule.qryCadastroPontoUnidade.ParamByName('sPonto').AsInteger := sPonto;
             UniMainModule.qryCadastroPontoUnidade.ExecSQL;
          end;


          ShowMessage('Dados Excluídos');

          btnVoltarClick(Sender);
        end;
    end;
end;

procedure TfrmCadPontoUnidade.btnSairClick(Sender: TObject);
begin
  close;
end;

procedure TfrmCadPontoUnidade.btnVoltarClick(Sender: TObject);
begin
  edtUnidade.Clear;
  edtPonto.Clear;
  edtCEP.Clear;
  edtCNPJ.Clear;
  edtRua.Clear;
  edtBairro.Clear;
  edtNumero.Clear;
  edtCidade.Clear;
  cmbUF.ItemIndex := -1;
  edtPontoRef.Clear;

  btnCadastrar.Enabled := True;
  cmbUF.Enabled := True;
  edtUnidade.Enabled := True;
  edtCidade.Enabled := True;
  edtCNPJ.Enabled := True;
  edtPonto.Enabled := True;

  UniLabel12.Visible := False;

  UniMainModule.qryCadastroPontoUnidade.Active := False;
  UniMainModule.qryCadastroPontoUnidade.SQL.Clear;

  sSelect := ' select * from GRZ_LOC_ENDERECO_PONTOS';

  UniMainModule.qryCadastroPontoUnidade.SQL.Add(sSelect);
  UniMainModule.qryCadastroPontoUnidade.Active := True;

  UniMainModule.qryPontoUnidade.Active := False;
  UniMainModule.qryPontoUnidade.SQL.Clear;

  sSelect := ' select * from GRZ_LOC_PONTOS_UNIDADES';

  UniMainModule.qryPontoUnidade.SQL.Add(sSelect);
  UniMainModule.qryPontoUnidade.Active := True;

  edtUnidade.SetFocus;
end;

procedure TfrmCadPontoUnidade.cmbUFKeyPress(Sender: TObject; var Key: Char);
begin
   If key = #13 then
   Begin
      Key:= #0;
      edtPontoRef.SetFocus;
   end;
end;

procedure TfrmCadPontoUnidade.edtBairroKeyPress(Sender: TObject; var Key: Char);
begin
  If key = #13 then
   Begin
      Key:= #0;
      edtNumero.SetFocus;
   end;
end;

procedure TfrmCadPontoUnidade.edtCEPKeyPress(Sender: TObject; var Key: Char);
begin
  If key = #13 then
   Begin
      Key:= #0;
      edtCNPJ.SetFocus;
   end;
end;

procedure TfrmCadPontoUnidade.edtCidadeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if key = VK_TAB then
   begin
     if cmbUF.Enabled = False then
     begin
       edtPontoRef.SetFocus;
     end
     else
     begin
      cmbUF.Expand;
     end;
   end;
end;

procedure TfrmCadPontoUnidade.edtCidadeKeyPress(Sender: TObject; var Key: Char);
begin
  If key = #13 then
   Begin
      Key:= #0;

      if cmbUF.Enabled = False then
      begin
        edtPontoRef.SetFocus;
      end
      else
      begin
        cmbUF.Expand;
      end;
   end;
end;

procedure TfrmCadPontoUnidade.edtCNPJExit(Sender: TObject);
begin
   if AllTrim(edtCNPJ.Text) = '' then
   begin
     edtUnidade.Enabled := True;
     edtCidade.Enabled := True;
     exit;
   end
   else
   begin
     sCnpj := LimparCNPJ(AllTrim(edtCNPJ.Text));

     UniMainModule.qryConsultaUnidade.Active := False;
     UniMainModule.qryConsultaUnidade.SQL.Clear;

     sSelect := ' select * from ps_juridicas '+
                ' where num_cgc = :sCnpj ';

     UniMainModule.qryConsultaUnidade.SQL.Add(sSelect);

     UniMainModule.qryConsultaUnidade.ParamByName('sCnpj').AsString := sCnpj;

     UniMainModule.qryConsultaUnidade.Active := True;

     if UniMainModule.qryConsultaUnidade.RecordCount = 0 then
     begin
       ShowMessage('CNPJ Informado não está cadastrado');
       edtCNPJ.SetFocus;
       exit;
     end
     else
     begin
       UniMainModule.qryConsultaUnidade.Active := False;
       UniMainModule.qryConsultaUnidade.SQL.Clear;

       sSelect := ' select a.cod_unidade, '+
                  '        a.des_fantasia '+
                  ' from v_unidades a, '+
                  '      ps_juridicas b '+
                  ' where a.num_cgc = b.num_cgc '+
                  ' and a.num_cgc = :sCnpj ';

      UniMainModule.qryConsultaUnidade.SQL.Add(sSelect);

      UniMainModule.qryConsultaUnidade.ParamByName('sCnpj').AsString := sCnpj;

      UniMainModule.qryConsultaUnidade.Active := True;

      if UniMainModule.qryConsultaUnidade.RecordCount = 0 then
       begin
         ShowMessage('Erro ao consultar CNPJ');
         edtUnidade.Enabled := True;
         edtCidade.Enabled := True;
         exit;
       end
       else
       begin
         edtUnidade.Text := UniMainModule.qryConsultaUnidade.FieldByName('cod_unidade').AsString;
         edtCidade.Text := Copy(UniMainModule.qryConsultaUnidade.FieldByName('des_fantasia').AsString,4);

         edtUnidade.Enabled := False;
         edtCidade.Enabled := False;
       end;
     end;


   end;

end;

procedure TfrmCadPontoUnidade.edtCNPJKeyPress(Sender: TObject; var Key: Char);
begin
  If key = #13 then
   Begin
      Key:= #0;
      edtRua.SetFocus;
   end;
end;

procedure TfrmCadPontoUnidade.edtNumeroKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if key = VK_TAB then
   begin
     if edtCidade.Enabled = True then
     begin
       edtCidade.SetFocus;
     end
     else
     begin
      cmbUF.Expand;
     end;
   end;
end;

procedure TfrmCadPontoUnidade.edtNumeroKeyPress(Sender: TObject; var Key: Char);
begin
  If key = #13 then
   Begin
      Key:= #0;
      if edtCidade.Enabled = True then
      begin
        edtCidade.SetFocus;
      end
      else
      begin
        cmbUF.Expand;
      end;
   end;
end;

procedure TfrmCadPontoUnidade.edtPontoKeyPress(Sender: TObject; var Key: Char);
begin
  If key = #13 then
   Begin
      Key:= #0;
      edtCEP.SetFocus;
   end;
end;

procedure TfrmCadPontoUnidade.edtPontoRefKeyPress(Sender: TObject;
  var Key: Char);
begin
   If key = #13 then
   Begin
      Key:= #0;
      btnCadastrar.SetFocus;
   end;
end;

procedure TfrmCadPontoUnidade.edtRuaKeyPress(Sender: TObject; var Key: Char);
begin
  If key = #13 then
   Begin
      Key:= #0;
      edtBairro.SetFocus;
   end;
end;

procedure TfrmCadPontoUnidade.edtUnidadeExit(Sender: TObject);
begin
  if AllTrim(edtUnidade.Text) = '' then
  begin
    exit;
  end
  else
  begin
    sUnidade := StrToInt(AllTrim(edtUnidade.Text));

    UniMainModule.qryConsultaUnidade.Active := False;
    UniMainModule.qryConsultaUnidade.SQL.Clear;

    sSelect := ' select cod_unidade '+
               ' from v_unidades '+
               ' where cod_unidade = :sUnidade ';

    UniMainModule.qryConsultaUnidade.SQL.Add(sSelect);

    UniMainModule.qryConsultaUnidade.ParamByName('sUnidade').AsInteger := sUnidade;

    UniMainModule.qryConsultaUnidade.Active := True;

    if UniMainModule.qryConsultaUnidade.RecordCount > 0 then
    begin
      UniMainModule.qryCadastroPontoUnidade.Active := False;
      UniMainModule.qryCadastroPontoUnidade.SQL.Clear;

      sSelect := ' select * from '+
                 ' GRZ_LOC_ENDERECO_PONTOS a,'+
                 ' GRZ_LOC_PONTOS_UNIDADES b '+
                 ' where a.cod_ponto = b.cod_ponto '+
                 ' and b.cod_unidade = :sUnidade ';

      UniMainModule.qryCadastroPontoUnidade.SQL.Add(sSelect);
      UniMainModule.qryCadastroPontoUnidade.ParamByName('sUnidade').AsInteger := sUnidade;
      UniMainModule.qryCadastroPontoUnidade.Active := True;

      UniMainModule.qryPontoUnidade.Active := False;
      UniMainModule.qryPontoUnidade.SQL.Clear;

      sSelect := ' select * from '+
                 ' GRZ_LOC_ENDERECO_PONTOS a,'+
                 ' GRZ_LOC_PONTOS_UNIDADES b '+
                 ' where a.cod_ponto = b.cod_ponto '+
                 ' and b.cod_unidade = :sUnidade ';

      UniMainModule.qryPontoUnidade.SQL.Add(sSelect);
      UniMainModule.qryPontoUnidade.ParamByName('sUnidade').AsInteger := sUnidade;
      UniMainModule.qryPontoUnidade.Active := True;

      if UniMainModule.qryCadastroPontoUnidade.RecordCount > 0 then
      begin
        edtPonto.Text := UniMainModule.qryCadastroPontoUnidade.FieldByName('COD_PONTO').AsString;
        edtPonto.Enabled := False;
        edtCEP.Text := UniMainModule.qryCadastroPontoUnidade.FieldByName('NUM_CEP').AsString;
        edtCNPJ.Text := UniMainModule.qryCadastroPontoUnidade.FieldByName('NUM_CNPJ').AsString;
        edtRua.Text := UniMainModule.qryCadastroPontoUnidade.FieldByName('DES_RUA').AsString;
        edtBairro.Text := UniMainModule.qryCadastroPontoUnidade.FieldByName('DES_BAIRRO').AsString;
        edtNumero.Text := UniMainModule.qryCadastroPontoUnidade.FieldByName('DES_NUMERO').AsString;
        edtCidade.Text := UniMainModule.qryCadastroPontoUnidade.FieldByName('DES_CIDADE').AsString;
        if UniMainModule.qryCadastroPontoUnidade.FieldByName('DES_UF').AsString = 'RS' then
        begin
          cmbUF.ItemIndex := 0;
        end;

        if UniMainModule.qryCadastroPontoUnidade.FieldByName('DES_UF').AsString = 'SC' then
        begin
          cmbUF.ItemIndex := 1;
        end;

        if UniMainModule.qryCadastroPontoUnidade.FieldByName('DES_UF').AsString = 'PR' then
        begin
          cmbUF.ItemIndex := 2;
        end;

        cmbUF.Enabled := False;
        edtCNPJ.Enabled := False;

        edtPontoRef.Text := UniMainModule.qryCadastroPontoUnidade.FieldByName('DES_PONTO_REF').AsString;

        btnCadastrar.Enabled := False;
        btnEditar.Enabled := True;
        btnExcluir.Enabled := True;
        edtCEP.SetFocus;
        UniLabel12.Visible := False;

      end
      else
      begin
        UniMainModule.qryConsultaUnidade.Active := False;
        UniMainModule.qryConsultaUnidade.SQL.Clear;

        sSelect := ' select a.num_cgc, '+
                   '        a.des_fantasia '+
                   ' from v_unidades a, '+
                   '      ps_juridicas b '+
                   ' where a.num_cgc = b.num_cgc '+
                   ' and a.cod_unidade = :sUnidade ';

        UniMainModule.qryConsultaUnidade.SQL.Add(sSelect);

        UniMainModule.qryConsultaUnidade.ParamByName('sUnidade').AsInteger := sUnidade;

        UniMainModule.qryConsultaUnidade.Active := True;

        if UniMainModule.qryConsultaUnidade.RecordCount = 0 then
        begin
           edtPonto.Enabled := True;
            edtPonto.SetFocus;
            cmbUF.Enabled := True;
            btnCadastrar.Enabled := True;
            btnEditar.Enabled := False;
            btnExcluir.Enabled := False;
            edtCNPJ.Enabled := True;
            edtCidade.Enabled := True;

            edtPonto.Clear;
            edtCEP.Clear;
            edtCNPJ.Clear;
            edtRua.Clear;
            edtBairro.Clear;
            edtNumero.Clear;
            edtCidade.Clear;
            cmbUF.ItemIndex := -1;
            edtPontoRef.Clear;
            UniLabel12.Visible := True;
        end
        else
        begin
          edtCNPJ.Text := UniMainModule.qryConsultaUnidade.FieldByName('num_cgc').AsString;
          edtCNPJ.Enabled := False;
          edtCidade.Text := Copy(UniMainModule.qryConsultaUnidade.FieldByName('des_fantasia').AsString,4);
          edtCidade.Enabled := False;
        end;

      end;

    end
    else
    begin
      ShowMessage('Unidade Inexistente');
      edtUnidade.Clear;
      edtUnidade.SetFocus;
      btnVoltarClick(Sender);
      exit;
    end;


  end;
end;

procedure TfrmCadPontoUnidade.edtUnidadeKeyPress(Sender: TObject;
  var Key: Char);
begin
  If key = #13 then
   Begin
      Key:= #0;
      edtPonto.SetFocus;
   end;
end;

procedure TfrmCadPontoUnidade.UniDBGrid1CellClick(Column: TUniDBGridColumn);
begin
  btnCadastrar.Enabled := False;
  btnEditar.Enabled := True;
  btnExcluir.Enabled := True;

  edtPonto.Enabled := False;
  cmbUF.Enabled := False;

   edtUnidade.Enabled := True;
  edtCidade.Enabled := False;
  edtCNPJ.Enabled := False;

  edtCEP.Text := UniMainModule.qryCadastroPontoUnidade.FieldByName('num_cep').AsString;
  edtCNPJ.Text := UniMainModule.qryCadastroPontoUnidade.FieldByName('num_cnpj').AsString;
  edtRua.Text := UniMainModule.qryCadastroPontoUnidade.FieldByName('des_rua').AsString;
  edtBairro.Text := UniMainModule.qryCadastroPontoUnidade.FieldByName('des_bairro').AsString;
  edtNumero.Text := UniMainModule.qryCadastroPontoUnidade.FieldByName('des_numero').AsString;
  edtCidade.Text := UniMainModule.qryCadastroPontoUnidade.FieldByName('des_cidade').AsString;

  if UniMainModule.qryCadastroPontoUnidade.FieldByName('des_uf').AsString = 'RS' then
  begin
    cmbUF.ItemIndex := 0;
  end;

  if UniMainModule.qryCadastroPontoUnidade.FieldByName('des_uf').AsString = 'SC' then
  begin
    cmbUF.ItemIndex := 1;
  end;

  if UniMainModule.qryCadastroPontoUnidade.FieldByName('des_uf').AsString = 'PR' then
  begin
    cmbUF.ItemIndex := 3;
  end;

  edtPontoRef.Text := UniMainModule.qryCadastroPontoUnidade.FieldByName('des_ponto_ref').AsString;

end;

procedure TfrmCadPontoUnidade.UniFormShow(Sender: TObject);
begin
  UniMainModule.qryCadastroPontoUnidade.Active := False;
  UniMainModule.qryCadastroPontoUnidade.SQL.Clear;

  sSelect := ' select * from GRZ_LOC_ENDERECO_PONTOS '+
             ' order by cod_ponto ';

  UniMainModule.qryCadastroPontoUnidade.SQL.Add(sSelect);
  UniMainModule.qryCadastroPontoUnidade.Active := True;

  UniMainModule.qryPontoUnidade.Active := False;
  UniMainModule.qryPontoUnidade.SQL.Clear;

  sSelect := ' select * from GRZ_LOC_PONTOS_UNIDADES '+
             ' order by cod_ponto ';

  UniMainModule.qryPontoUnidade.SQL.Add(sSelect);
  UniMainModule.qryPontoUnidade.Active := True;

//  edtUnidade.SetFocus;

  btnCadastrar.Enabled := True;
  btnEditar.Enabled := False;
  btnExcluir.Enabled := False;
  UniLabel12.Visible := False;
end;

end.
