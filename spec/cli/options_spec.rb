require 'spec_helper'
require 'retorno_boleto/options'
require 'pry'

RSpec.describe RetornoBoleto::Options do
  subject { }

  it 'defaults format to CNAB400' do
    options = described_class.new(["-b", "HSBC", "filepath.rem"]).parse
    expect(options.to_h[:format]).to eq("CNAB400")
  end

  it 'requires the bank' do
    options = described_class.new(["filepath.rem"])
    expect{options.parse}.to raise_error(/bank/)
  end

  it 'requires a path' do
    options = described_class.new(["-b", "HSBC"])
    expect{options.parse}.to raise_error(/paths/)
  end
end
