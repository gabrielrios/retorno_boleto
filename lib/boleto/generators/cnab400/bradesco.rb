require 'date'
module Boleto
  module Generators
    module Cnab400
      class Bradesco
        def initialize(path)
          @parser = ::Boleto::Parsers::Cnab400::Bradesco.new(path)
        end
        attr_reader :parser

        def perform
          parser.parse!
          content = []
          content << header
          content += parser.pagamentos.map do |pagamento|
            nosso_numero = "#{pagamento[:nosso_numero]}#{pagamento[:nosso_numero_dv]}"
            ret_pagamento = '1'
            ret_pagamento << '02'  # Empresa
            ret_pagamento << ''.rjust(14, '0') # We don't have the company number
            ret_pagamento << ''.rjust(3, '0')
            ret_pagamento << pagamento[:identificacao_empresa].rjust(17, " ")
            ret_pagamento << pagamento[:numero_controle].rjust(25, " ")
            ret_pagamento << ''.rjust(8, '0')
            ret_pagamento << nosso_numero.rjust(12, '0')
            ret_pagamento << ''.rjust(10, '0')
            ret_pagamento << ''.rjust(12, ' ')
            ret_pagamento << pagamento[:indicador_rateio].rjust(1, "R")
            ret_pagamento << ''.rjust(2, '0')
            ret_pagamento << pagamento[:identificacao_empresa][3]
            ret_pagamento << '02'
            ret_pagamento << Date.today.strftime('%d%m%y')
            ret_pagamento << pagamento[:numero_documento].rjust(10, " ")
            ret_pagamento << nosso_numero.rjust(20, ' ')
            ret_pagamento << pagamento[:data_vencimento]
            ret_pagamento << pagamento[:valor_titulo]
            ret_pagamento << pagamento[:codigo_do_banco]
            ret_pagamento << pagamento[:agencia]
            ret_pagamento << pagamento[:moeda]
            ret_pagamento << ''.rjust(13, '0')  # Despesas de cobrança
            ret_pagamento << ''.rjust(13, '0')  # Outras despesas
            ret_pagamento << ''.rjust(13, '0')  # Juros
            ret_pagamento << ''.rjust(13, '0')  # IOF
            ret_pagamento << ''.rjust(13, '0')  # Abatimento
            ret_pagamento << ''.rjust(13, '0')  # Desconto concedido
            ret_pagamento << pagamento[:valor_titulo] # valor Pago
            ret_pagamento << ''.rjust(13, '0') # Juros de Mora
            ret_pagamento << ''.rjust(13, '0')  # Outro c'reditos
            ret_pagamento << ''.rjust(2, ' ')
            ret_pagamento << ' ' # Motivo do Código de Ocorrência 25
            ret_pagamento << Date.today.strftime('%d%m%y') # Data do Crédito
            ret_pagamento << ''.rjust(3, '0') # Origem Pagamento
            ret_pagamento << ''.rjust(10, ' ')
            ret_pagamento << ''.rjust(4, ' ')
            ret_pagamento << '00'.rjust(10, '0') # Motivo dsa Rejeições
            ret_pagamento << ''.rjust(40, ' ')
            ret_pagamento << ''.rjust(2, '0') # Numero do Cartorio
            ret_pagamento << ''.rjust(10, '0') # Numero do Protocolo
            ret_pagamento << ''.rjust(14, '0')
            ret_pagamento << pagamento[:sequencial]
            ret_pagamento
          end

          return content.join("\n")
        end

        def header
          header = "02RETORNO01COBRANCA"
          header << parser.header[:codigo_empresa].to_s
          header << parser.header[:nome_empresa]
          header << parser.header[:cod_banco]
          header << parser.header[:nome_banco]
          header << parser.header[:data_geracao]
          header << '01600000'
          header << ''.rjust(5, '0')
          header << ''.rjust(266, ' ')
          header << Date.today.strftime('%d%m%y')
          header << ''.rjust(0, ' ')
          header << parser.header[:sequencial]
          header
        end
      end
    end
  end
end
