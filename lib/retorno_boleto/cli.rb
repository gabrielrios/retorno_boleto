require 'retorno_boleto'
require 'retorno_boleto/options'
require 'retorno_boleto/generator'

module RetornoBoleto
  class Cli
    STATUS_SUCCESS = 0
    STATUS_ERROR   = 1

    def initialize(argv)
      @options = Options.new(argv)
    end

    def execute
      parsed_options = @options.parse

      if parsed_options.help?
        print(parsed_options.to_h[:help_text])
      elsif parsed_options.version?
        print(VERSION)
      else
        generator = RetornoBoleto::Generator.for(parsed_options.to_h)
        print(generator.perform)
      end
      STATUS_SUCCESS
    rescue OptionParser::InvalidOption, OptionParser::MissingArgument => error
      $stderr.puts "Error: #{error}"
      STATUS_ERROR
    end

    def print(message)
      $stdout.puts message
    end
  end
end
