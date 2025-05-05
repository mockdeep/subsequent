# frozen_string_literal: true

RSpec.configure do |config|
  config.around do |example|
    example.run
  rescue SystemExit => e
    puts e.backtrace
    raise StandardError, "uncaught SystemExit"
  end
end
