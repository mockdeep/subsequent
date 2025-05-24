# frozen_string_literal: true

# Add checklist mode functionality
module Subsequent::Modes::AddChecklist
  extend Subsequent::Modes::Base
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  INPUT_METHOD = :gets

  OPTIONS = [
    Subsequent::Options::Cancel,
    Subsequent::Options::CreateChecklist,
  ].freeze

  class << self
    # add checklist mode commands
    def commands(_state)
      "enter checklist name (#{cyan("q")}) to cancel: "
    end
  end
end
