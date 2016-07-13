require 'spec_helper'
require 'boleto/parsers/cnab400/bradesco'

RSpec.describe Boleto::Parsers::Cnab400::Bradesco do
  let(:pagamento) do
    Brcobranca::Remessa::Pagamento.new(valor: 199.9,
      data_vencimento: Date.current,
      nosso_numero: 123,
      documento_sacado: '12345678901',
      nome_sacado: 'PABLO DIEGO JOSÉ FRANCISCO DE PAULA JUAN NEPOMUCENO MARÍA DE LOS REMEDIOS CIPRIANO DE LA SANTÍSSIMA TRINIDAD RUIZ Y PICASSO',
      endereco_sacado: 'RUA RIO GRANDE DO SUL São paulo Minas caçapa da silva junior',
      bairro_sacado: 'São josé dos quatro apostolos magros',
      cep_sacado: '12345678',
      cidade_sacado: 'Santa rita de cássia maria da silva',
      uf_sacado: 'SP')
  end
  let(:params) do
    { carteira: '01',
      agencia: '12345',
      conta_corrente: '1234567',
      digito_conta: '1',
      empresa_mae: 'SOCIEDADE BRASILEIRA DE ZOOLOGIA LTDA',
      sequencial_remessa: '1',
      codigo_empresa: '123',
      pagamentos: [pagamento] }
  end
  let(:bradesco) { Brcobranca::Remessa::Cnab400::Bradesco.new(params) }
  let(:tmpfile) { Tempfile.new("remessa_bradesco") }
  let(:parser) { Boleto::Parsers::Cnab400::Bradesco.new(tmpfile) }

  before do
    tmpfile.write(bradesco.gera_arquivo)
    tmpfile.rewind
    parser.parse!
  end

  let(:header) { parser.header }

  it "parses the header" do
    expect(header[:tipo]).to eq('0')
    expect(header[:operacao]).to eq('1')
    expect(header[:literal]).to eq("REMESSA")
    expect(header[:codigo_servico]).to eq("01")
    expect(header[:codigo_empresa]).to eq(bradesco.info_conta)
    expect(header[:nome_empresa]).to eq(params[:empresa_mae].format_size(30))
    expect(header[:cod_banco]).to eq("237")
    expect(header[:nome_banco]).to match(/bradesco/i)
    expect(header[:data_geracao]).to eq(Date.today.strftime("%d%m%y"))
    expect(header[:identificacao_sistema]).to match(/MX/)
    expect(header[:sequencial_remessa]).to eq('1'.rjust(7, '0'))
    expect(header[:sequencial]).to eq('000001')
  end

  let(:payment) { parser.pagamentos.first }

  it "parses the payments" do
    expect(payment[:data_vencimento]).to eq(Date.current.strftime("%d%m%y"))
    expect(payment[:identificacao_titulo]).to eq("123".rjust(11, '0'))
    expect(payment[:digito_autoconferencia]).to eq('P')
    expect(payment[:cpf_cnpj_pagador]).to eq(pagamento.documento_sacado.rjust(14, '0'))
    expect(payment[:nome_pagador]).to eq(pagamento.nome_sacado.format_size(40))
    expect(payment[:valor_titulo]).to eq("19990".rjust(13, "0"))
    expect(payment[:data_emissao]).to eq(Date.current.strftime("%d%m%y"))
    expect(payment[:identificacao_empresa][1..3]).to eq('001')
    expect(payment[:sequencial]).to eq("2".rjust(6, '0'))
  end
end

