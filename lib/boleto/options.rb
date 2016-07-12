require 'optparse'

module Boleto
  class Options
    def initialize(argv)
      @argv = argv
      @format = "CNAB400"
    end

    def parse
      @parser = OptionParser.new do |opts|
        opts.banner = 'Usage: retorno [options] paths'

        opts.on("-b", "--bank BANK", "which bank you're testing") do |bank|
          @bank = bank
        end

        opts.on('-f', '--format [FORMAT]', 'which format will be used. Default: CNAB400') do |format|
          @format = format
        end

        opts.on_tail('-v', '--version', "Show gem's version") do
          @mode = :version
        end

        opts.on_tail('-h', '--help', 'Show this message') do
          @mode = :help
        end
      end
      @parser.parse!(@argv)

      if run?
      raise OptionParser::MissingArgument.new("bank") if @bank.nil?
      raise OptionParser::MissingArgument.new("paths") if paths.empty?
      end
      self
    end

    def run?
      @mode != :help && @mode != :version
    end

    def help?
      @mode == :help
    end

    def version?
      @mode == :version
    end

    def to_h
      {
        bank: @bank,
        mode: @mode,
        format: @format,
        paths: paths,
        help_text: @parser.help,
      }
    end

    private

    def paths
      @argv
    end
  end
end
