# frozen_string_literal: true

class StringIO
  def clear_screen
    string.clear
  end
end

module IOHelpers
  include Subsequent::Configuration::Helpers

  def mock_input(chars)
    input.print(chars)
    input.rewind
  end
end

RSpec.configure do |config|
  config.include(IOHelpers)

  config.before do
    Subsequent::Actions::Spin::SPINNER.rewind
    Subsequent::Configuration.input = StringIO.new
    Subsequent::Configuration.output = StringIO.new
  end
end
