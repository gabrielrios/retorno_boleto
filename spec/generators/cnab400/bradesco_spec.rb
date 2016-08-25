require 'spec_helper'
require 'retorno_boleto/generators/cnab400/bradesco'
require 'pry'

RSpec.describe RetornoBoleto::Generators::Cnab400::Bradesco do
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
  let(:tmpfile) do
    tmp = Tempfile.new("remessa_bradesco")
    tmp.write(bradesco.gera_arquivo)
    tmp.rewind
    tmp
  end

  let(:generator) { RetornoBoleto::Generators::Cnab400::Bradesco.new(tmpfile) }
  let(:tmp_retorno) do
    tmp = Tempfile.new("remessa_bradesco")
    tmp.write(generator.perform)
    tmp.rewind
    tmp
  end
  let(:retorno) { Brcobranca::Retorno::Cnab400::Bradesco.load_lines(tmp_retorno) }

  it 'generates a proper header' do
    header = tmp_retorno.readline
    expect(header[0..10]).to eq("02RETORNO01")
    expect(header[11..25]).to eq("COBRANCA".rjust(15, " "))
    expect(header[46..75]).to eq('SOCIEDADE BRASILEIRA DE ZOOLOGIA LTDA'.format_size(30))
    expect(header[76..78]).to eq("237")
    expect(header[94..99]).to eq(Date.current.strftime("%d%m%y"))
    expect(header[379..384]).to eq(Date.current.strftime("%d%m%y"))
  end

  it 'generates a proper payment' do
    payment = retorno.first

    expect(payment.carteira).to eq('001')
    expect(payment.agencia_sem_dv).to eq('12345')
    expect(payment.cedente_com_dv).to eq('12345671')
    expect(payment.nosso_numero[0...-1]).to eq('123'.rjust(11, '0'))
    expect(payment.cod_de_ocorrencia).to eq('02')
    expect(payment.data_vencimento).to eq(Date.current.strftime('%d%m%y'))
    expect(payment.valor_titulo).to eq('19990'.rjust(13, '0'))
    expect(payment.banco_recebedor).to eq('000')
    expect(payment.especie_documento).to eq('99')
    expect(payment.valor_tarifa).to eq(''.rjust(13, '0'))
    expect(payment.iof).to eq(''.rjust(13, '0'))
    expect(payment.valor_abatimento).to eq(''.rjust(13, '0'))
    expect(payment.desconto).to eq(''.rjust(13, '0'))
    expect(payment.valor_recebido).to eq('19990'.rjust(13, '0'))
    expect(payment.juros_mora).to eq(''.rjust(13, '0'))
    expect(payment.outros_recebimento).to eq(''.rjust(13, '0'))
    expect(payment.data_credito).to eq(Date.current.strftime('%d%m%y'))
    expect(payment.sequencial).to eq("2".rjust(6, '0'))
  end

end
