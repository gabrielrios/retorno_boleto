require 'boleto'
require 'boleto/options'
require 'boleto/generator'
require 'pry'

module Boleto
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
        generator = Boleto::Generator.new(parsed_options.to_h)
        generator.perform
        print(generator.result)
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
