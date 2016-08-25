require 'spec_helper'
require 'retorno_boleto/generator'

RSpec.describe RetornoBoleto::Generator do
  it 'fetch class for options' do
    options = { format: 'cnab400', bank: 'bradesco', paths: [""] }
    generator = RetornoBoleto::Generator.for(options)
    expect(generator).to be_kind_of(RetornoBoleto::Generators::Cnab400::Bradesco)
  end
end
