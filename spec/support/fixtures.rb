# frozen_string_literal: true

module Fixtures
  def fixture_path(path)
    File.join(__dir__, "../", "fixtures", path)
  end
end

RSpec.configure do |config|
  config.include(Fixtures)

  config.before do
    Subsequent::TrelloClient.config_path = fixture_path("config.yml")
  end
end
