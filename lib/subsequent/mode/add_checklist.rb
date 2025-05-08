# frozen_string_literal: true

# Add checklist mode functionality
module Subsequent::Mode::AddChecklist
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  # add checklist mode commands
  def self.commands(_state)
    ["enter checklist name (#{cyan("q")}) to cancel: "]
  end

  # handle input for add checklist mode
  def self.handle_input(state)
    text = input.gets.to_s.squish

    case text
    when "", "q", "\u0004", "\u0003"
      state.with(mode: Subsequent::Mode::Normal)
    else
      Subsequent::Commands::CreateChecklist.call(state, text)
    end
  end
end
