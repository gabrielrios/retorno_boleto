# RetornoBoleto

Sempre que estamos desenvolvendo algum sistema que precise fazer geração
de boletos bancários, um dos grandes problemas é como realizar o testes
desta integração.

Isto acontece pois é necessário um arquivo de retorno gerado pelo banco para
que possamos testar o processamento do pagamento.

Na maioria das empresas aonde trabalhei, simplesmente gerávamos um
boleto com valor baixo e pagávamos para poder assim termos esse retorno,
porém isso atrasa o desenvolvimento da tarefa.

Para agilizar este processo, criei essa gem que cria arquivos de retorno
para os bancos assim podendo integrar direto no desenvolvimento.

DISCLAIMER: O teste da integração diretamente como Banco ainda se faz
necessário, essa gem é apenas uma ajuda para acelerar esse processo

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'retorno_boleto'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install retorno_boleto

## Usage

  Para gerar o arquivo de retorno precisamos passar para a ferramenta
  qual o Banco, o formato do arquivo e o Arquivo de remessa

    $ retorno_boleto --bank bradesco --format cnab400 remessa_bradesco.txt


OBS: Atualmente somente Bradesco e Cnab400 são suportados

    $ Usage: retorno [options] paths
        -b, --bank BANK                  which bank you're testing
        -f, --format [FORMAT]            which format will be used. Default: CNAB400
        -v, --version                    Show gem's version
        -h, --help                       Show this message




## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gabrielrios/retorno_boleto. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

