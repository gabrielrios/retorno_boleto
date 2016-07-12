# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'boleto/version'

Gem::Specification.new do |spec|
  spec.name          = "boleto"
  spec.version       = Boleto::VERSION
  spec.authors       = ["Gabriel Rios"]
  spec.email         = ["gabrielfalcaorios@gmail.com"]

  spec.summary       = %q{Gera arquivos de retorno de boletos para testes}
  spec.description   = %q{Gera arquivos de retorno de boletos para test}
  spec.homepage      = "http://github.com/gabrielrios/boleto"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"

  spec.add_dependency "brcobranca"
end
