require 'boleto/generators'
module Boleto
  class Generator
    def self.for(options)
      format = Generators.const_get(options[:format].capitalize)
      bank = format.const_get(options[:bank].capitalize)
      bank.new(options[:paths].first)
    end
  end
end
