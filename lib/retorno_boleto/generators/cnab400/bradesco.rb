require 'date'
module RetornoBoleto
  module Generators
    module Cnab400
      class Bradesco
        def initialize(path)
          @parser = ::RetornoBoleto::Parsers::Cnab400::Bradesco.new(path)
        end
        attr_reader :parser

        def perform
          parser.parse!
          content = []
          content << header
          content += parser.pagamentos.map do |pagamento|
            identificacao_titulo = "#{pagamento[:identificacao_titulo]}#{pagamento[:digito_autoconferencia]}"
            ret_pagamento = '1'                                                #  1 - Codigo do Registro
            ret_pagamento << '02'                                              #  2 - Tipo de Inscrição da Empresa
            ret_pagamento << ''.rjust(14, '0')                                 #  3 - Numero de Inscricao da Empresa
            ret_pagamento << ''.rjust(3, '0')                                  #  4 - Zero
            ret_pagamento << pagamento[:identificacao_empresa].rjust(17, " ")  #  5 - Identificacao Empresa
            ret_pagamento << pagamento[:numero_controle].rjust(25, " ")        #  6 - Numero Controle do Participante
            ret_pagamento << ''.rjust(8, '0')                                  #  7 - Zeros
            ret_pagamento << identificacao_titulo.rjust(12, '0')               #  8 - Identificacao do Titulo no Banco
            ret_pagamento << ''.rjust(10, '0')                                 #  9 - Uso do Banco
            ret_pagamento << ''.rjust(12, ' ')                                 # 10 - Uso do Banco
            ret_pagamento << pagamento[:indicador_rateio].rjust(1, "R")        # 11 - Indcador de Rateio
            ret_pagamento << ''.rjust(2, '0')
            ret_pagamento << pagamento[:identificacao_empresa][3]
            ret_pagamento << '02'
            ret_pagamento << Date.today.strftime('%d%m%y')
            ret_pagamento << pagamento[:numero_documento].rjust(10, "0")
            ret_pagamento << identificacao_titulo.rjust(20, '0')
            ret_pagamento << pagamento[:data_vencimento].rjust(6, '0')
            ret_pagamento << pagamento[:valor_titulo].rjust(13, '0')
            ret_pagamento << pagamento[:codigo_do_banco].rjust(3, '0')
            ret_pagamento << pagamento[:agencia].rjust(5, '0')
            ret_pagamento << pagamento[:moeda].rjust(2, '0')
            ret_pagamento << ''.rjust(13, '0')  # Despesas de cobrança
            ret_pagamento << ''.rjust(13, '0')  # Outras despesas
            ret_pagamento << ''.rjust(13, '0')  # Juros
            ret_pagamento << ''.rjust(13, '0')  # IOF
            ret_pagamento << ''.rjust(13, '0')  # Abatimento
            ret_pagamento << ''.rjust(13, '0')  # Desconto concedido
            ret_pagamento << pagamento[:valor_titulo].rjust(13, '0') # valor Pago
            ret_pagamento << ''.rjust(13, '0') # Juros de Mora
            ret_pagamento << ''.rjust(13, '0')  # Outro c'reditos
            ret_pagamento << ''.rjust(2, ' ')
            ret_pagamento << ''.rjust(1, ' ') # Motivo do Código de Ocorrência 25
            ret_pagamento << Date.today.strftime('%d%m%y') # Data do Crédito
            ret_pagamento << ''.rjust(3, '0') # Origem Pagamento
            ret_pagamento << ''.rjust(10, ' ')
            ret_pagamento << ''.rjust(4, ' ')
            ret_pagamento << '00'.rjust(10, '0') # Motivo dsa Rejeições
            ret_pagamento << ''.rjust(40, ' ')
            ret_pagamento << ''.rjust(2, '0') # Numero do Cartorio
            ret_pagamento << ''.rjust(10, '0') # Numero do Protocolo
            ret_pagamento << ''.rjust(14, '0')
            ret_pagamento << pagamento[:sequencial].rjust(6, '0')
            ret_pagamento
          end

          return content.join("\n")
        end

        def header
          header = "02RETORNO01"
          header << "COBRANCA".rjust(15, " ")
          header << parser.header[:codigo_empresa].to_s.rjust(20, '0')
          header << parser.header[:nome_empresa].rjust(30, ' ')
          header << "237"
          header << parser.header[:nome_banco].rjust(15, ' ')
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
