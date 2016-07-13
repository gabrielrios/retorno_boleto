require 'spec_helper'
require 'boleto/generators/cnab400/bradesco'

RSpec.describe Boleto::Generators::Cnab400::Bradesco do
  let(:path) { fixture_path("remessa_bradesco_cnab400.rem") }
  let(:options) { {paths: path} }


  it 'parses the file' do
    generator = described_class.new(path)
  end
end
