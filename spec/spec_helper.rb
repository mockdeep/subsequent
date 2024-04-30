# frozen_string_literal: true

require_relative "support/coverage"
require_relative "support/webmock"

require_relative "../lib/subsequent"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do
    Subsequent::TrelloClient.config_path =
      File.join(__dir__, "fixtures", "config.yml")
  end
end
