require 'retorno_boleto/parser'

module RetornoBoleto
  module Parsers
    module Cnab400
      class Bradesco
        include FixedWidthParser # Extendendo parseline

        def initialize(file, options = {})
          @file  = file
        end

        def parse!
          @lines = File.readlines(@file)
          @header     = parse_header
          @pagamentos = parse_pagamentos
        end

        attr_reader :header, :pagamentos

        def parse_header
          parse_lines(@lines[0..0]) do |parse|
            parse.field :tipo,                 0..0      # Identificação do Registro
            parse.field :operacao,             1..1      # Identificacao do Arquivo de Remessa
            parse.field :literal,              2..8      # Literal remessa
            parse_field :codigo_servico,       9..10     # Codigo de Serviço
            parse_field :nome_servico,         11..25    # Lietral Serviço
            parse_field :codigo_empresa,       26..45    # Codigo da Empresa
            parse_field :nome_empresa,         46..75    # Nome  da Empresa
            parse_field :cod_banco,            76..78    # Número do Bradesco na Câmara de Compensação
            parse_field :nome_banco,           79..93    # Nome do Banco Por Extenso
            parse_field :data_geracao,         94..99    # Data da Gravação do Arquivo
            parse_field :identificacao_sistema,  107..109  # Identificação do Sistema
            parse_field :sequencial_remessa,    110..116  # Número Sequencial da Remessa
            parse_field :sequencial,           394..399  # Núero Sequencial do Registro de Um em Um
          end.first
        end

        def parse_pagamentos
          parse_lines(@lines[1...-1]) do |parse|
            parse.field :id,                        0..0      #  1 - Identificação do Registro [1]
            parse.field :agencia,                   1..5      #  2 - Agência de Débito [5]
            parse.field :dv_agencia,                6..6      #  3 - Digito da Agência de Débito [1]
            parse.field :razao_conta,               7..11     #  4 - Razão da Conta Corrente [5]
            parse.field :conta_corrente,            12..18    #  5 - Conta Corrente [7]
            parse.field :dv_conta_corrente,         19..19    #  6 - Dígito da Conta Corrente [1]
            parse.field :identificacao_empresa,     20..36    #  7 - Identificação da Empresa no Banco [17]
            parse.field :numero_controle,           37..61    #  8 - Numero de Controle do Participante [25]
            parse.field :codigo_do_banco,           62..64    #  9 - Código do Banco a ser debitado [3]
            parse.field :campo_de_multa,            65..65    # 10 - Campo de Multa [1]
            parse.field :percentual_multa,          66..69    # 11 - Percentual de multa [4]
            parse.field :identificacao_titulo,      70..80    # 12 - Identificação do Título no Banco [11]
            parse.field :digito_autoconferencia,    81..81    # 13 - Digito de auto Conferencia do Número Bancário [1]
            parse.field :desconto_por_dia,          82..91    # 14 - Deconto Bonificação por dia [10]
            parse.field :condicao_emissao,          92..92    # 15 - Condição para Emissao da Papeleta de Cobrançå [1]
            parse.field :emite_debito,              93..93    # 16 - Ident se emite boleto para Débito Automático [1]
            parse.field :operacao_banco,            94..103   # 17 - Identificacao da Operação do Banco [10]
            parse.field :indicador_rateio,          104..104  # 18 - Indicador Rateio Crédito [1]
            parse.field :endereco,                  105..105  # 19 - Endereçamento para Aviso de De'bito Automatico [1]
            parse.field :branco_1,                  106..107  # 20 - Brancos [2]
            parse.field :identificacao_ocorrencia,  108..109  # 21 - Identificação da Ocorrência [2]
            parse.field :numero_documento,          110..119  # 22 - Número do Documento [10]
            parse.field :data_vencimento,           120..125  # 23 - Date de Vencimento do Tiítulo [6]
            parse.field :valor_titulo,              126..138  # 24 - Valor do Título [13]
            parse.field :banco_encarregado,         139..141  # 25 - Banco Encarregado da Cobrança [3]
            parse.field :agencia_depositaria,       132..146  # 26 - Agência Depositária [5]
            parse.field :moeda,                     147..148  # 27 - Espécie do Título [2]
            parse.field :identificacao,             149..149  # 28 - Identificação [1]
            parse.field :data_emissao,              150..155  # 29 - DAte de Emissão do título [6]
            parse.field :instrucao_1,               156..157  # 30 - Primeira Instrução [2]
            parse.field :instrucao_2,               158..159  # 31 - Segunda instrução [2]
            parse.field :mora,                      160..172  # 32 - Valor a ser cobrado por dia de atraso [13]
            parse.field :data_desconto,             173..178  # 33 - Data Limite P/Concessão de Desconto [6]
            parse.field :valor_desconto,            179..191  # 34 - Valor do Desconto [13]
            parse.field :valor_iof,                 192..204  # 35 - Valor do IOF [13]
            parse.field :valor_abatimento,          205..217  # 36 - VAlor do Abatimento [13]
            parse.field :tipo_pagador,              218..219  # 37 - Identificação do Tipo de Inscrição do Pagador [2]
            parse.field :cpf_cnpj_pagador,          220..233  # 38 - Número de Inscrição do Pagador [14]
            parse.field :nome_pagador,              234..273  # 39 - Nome do Pagador [40]
            parse.field :endereco_pagador,          274..313  # 40 - Endereço Completo [40]
            parse.field :mensagem_1,                314..325  # 41 - Primeira Mensagem [12]
            parse.field :cep_pagador,               326..330  # 42 - CEP [5]
            parse.field :cv_cep_pagador,            331..333  # 43 - Sufixo do CEP [3]
            parse.field :mensagem_2,                334..393  # 44 - Segunda Mensagem [60]
            parse.field :sequencial,                394..399  # 45 - Numero Sequenciadl do Registro [6]
          end
        end
      end
    end
  end
end
