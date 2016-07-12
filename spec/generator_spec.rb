require 'spec_helper'
require 'boleto/generator'

RSpec.describe Boleto::Generator do
  it 'fetch class for options' do
    options = { format: 'cnab400', bank: 'bradesco' }
    generator = Boleto::Generator.for(options)
    expect(generator).to be_kind_of(Boleto::Generators::Cnab400::Bradesco)
  end
end
