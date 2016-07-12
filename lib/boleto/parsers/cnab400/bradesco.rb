require 'boleto/parser'

module Boleto
  module Parsers
    module Cnab400
      class Bradesco
        include FixedWidthParser # Extendendo parseline

        def initialize(file, options = {})
          @lines      = File.readlines(file)
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
            parse_field :identificao_sistema,  107..109  # Identificação do Sistema
            parse_field :sequencia_remessa,    110..116  # Número Sequencial da Remessa
            parse_field :sequencial,           394..399  # Núero Sequencial do Registro de Um em Um
          end.first
        end

        def parse_pagamentos
          parse_lines(@lines[1...-1]) do |parse|
            parse.field :id,                        0..0      # Identificação do Registro
            parse.field :agencia,                   1..5      # Agência de Débito
            parse.field :dv_agencia,                6..6      # Digito da Agência de Débito
            parse.field :razao_conta,               7..11     # Razão da Conta Corrente
            parse.field :conta_corrente,            12..18    # Conta Corrente
            parse.field :dv_conta_corrente,         19..19    # Dígito da Conta Corrente
            parse.field :identificacao_empresa,     20..36    # Identificação da Empresa no Banco
            parse.field :numero_controle,           37..61    # Numero de Controle do Participante
            parse.field :codigo_do_banco,           62..64    # Código do Banco a ser debitado
            parse.field :campo_de_multa,            65..65    # Campo de Multa
            parse.field :percentual_multa,          66..69    # Percentual de multa
            parse.field :nosso_numero,              70..80    # Identificação do Título no Banco
            parse.field :nosso_numero_dv,           81..81    # Digito de auto Conferencia do Número Bancário
            parse.field :desconto_por_dia,          82..91    # Deconto Bonificação por dia
            parse.field :condicao_emissao,          92..92    # Condição para Emissao da Papeleta de Cobrançå
            parse.field :emite_debito,              93..93    # Ident se emite boleto para Débito Automático
            parse.field :operacao_banco,            94..103   # Identificacao da Operação do Banco
            parse.field :indicador_rateio,          104..104  # Indicador Rateio Crédito
            parse.field :endereco,                  105..105  # Endereçamento para Aviso de De'bito Automatico
            parse.field :identificacao_ocorrencia,  108..109  # Identificação da Ocorrência
            parse.field :numero_documento,          110..119  # Número do Documento
            parse.field :data_vencimento,           120..125  # Date de Vencimento do Tiítulo
            parse.field :valor_titulo,              126..138  # Valor do Título
            parse.field :moeda,                     147..148  # Espécie do Título
            parse.field :identificacao,             149..149  # Identificação
            parse.field :data_emissao,              150..155  # DAte de Emissão do título
            parse.field :instrucao_1,               156..157
            parse.field :instrucao_2,               158..159
            parse.field :mora,                      160..172  # Valor a ser cobrado por dia de atraso
            parse.field :data_desconto,             173..178  # Data Limite P/Concessão de Desconto
            parse.field :valor_desconto,            179..191  # Valor do Desconto
            parse.field :valor_iof,                 192..204  # Valor do IOF
            parse.field :valor_abatimento,          205..217  # VAlor do Abatimento
            parse.field :tipo_pagador,              218..219  # Identificação do Tipo de Inscrição do Pagador
            parse.field :cpf_cnpj_pagador,          220..233  # Número de Inscrição do Pagador
            parse.field :nome_pagador,              234..273  # Nome do Pagador
            parse.field :endereco_pagador,          274..313  # Endereço Completo
            parse.field :mensagem_1,                314..325
            parse.field :cep_pagador,               326..330  # CEP
            parse.field :cv_cep_pagador,            331..333  # Sufixo do CEP
            parse.field :mensagem_2,                334..393
            parse.field :sequencial,                394..399  # Numero Sequenciadl do Registro
          end
        end
      end
    end
  end
end
