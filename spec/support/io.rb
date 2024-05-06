# frozen_string_literal: true

class StringIO
  def clear_screen
    string.clear
  end
end

RSpec.configure do |config|
  config.before do
    Subsequent::Configuration.input = StringIO.new
    Subsequent::Configuration.output = StringIO.new
  end

  config.around do |example|
    example.run
  rescue SystemExit => e
    puts e.backtrace
    raise StandardError, "uncaught SystemExit"
  end
end
