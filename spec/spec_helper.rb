# frozen_string_literal: true

require_relative "support/coverage"

require_relative "../lib/subsequent"

require_relative "support/factories"
require_relative "support/fixtures"
require_relative "support/io"
require_relative "support/system_exit"
require_relative "support/trello"
require_relative "support/webmock"

RSpec.configure do |config|
  config.order = :random

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.filter_run(focus: true)
  config.run_all_when_everything_filtered = true

  config.expect_with(:rspec) do |c|
    c.syntax = :expect
  end
end
