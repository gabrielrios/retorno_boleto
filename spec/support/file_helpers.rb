module FileHelpers
  def fixture_path(relative_path)
    File.join(File.dirname(__FILE__), '..', 'fixtures', relative_path)
  end
end

RSpec.configure do |config|
  config.include FileHelpers
end
