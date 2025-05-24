# frozen_string_literal: true

# Add card mode functionality
module Subsequent::Modes::AddCard
  extend Subsequent::Modes::Base
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  INPUT_METHOD = :gets

  OPTIONS = [
    Subsequent::Options::Cancel,
    Subsequent::Options::CreateCard,
  ].freeze

  class << self
    # add card mode commands
    def commands(_state)
      "enter card name (#{cyan("q")}) to cancel: "
    end
  end
end
