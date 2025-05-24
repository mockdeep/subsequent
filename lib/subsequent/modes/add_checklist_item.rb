# frozen_string_literal: true

# Add checklist item mode functionality
module Subsequent::Modes::AddChecklistItem
  extend Subsequent::Modes::Base
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  INPUT_METHOD = :gets

  OPTIONS = [
    Subsequent::Options::Cancel,
    Subsequent::Options::CreateChecklistItem,
  ].freeze

  class << self
    # add checklist item mode commands
    def commands(_state)
      "enter checklist item name (#{cyan("q")}) to cancel: "
    end
  end
end
