# frozen_string_literal: true

# Add checklist item mode functionality
module Subsequent::Mode::AddChecklistItem
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  # add checklist item mode commands
  def self.commands(_state)
    ["enter checklist item name (#{cyan("q")}) to cancel: "]
  end

  # handle input for add checklist item mode
  def self.handle_input(state)
    text = input.gets.to_s.squish
    state => { checklist:, sort: }

    case text
    when "", "q", "\u0004", "\u0003"
      state.with(mode: Subsequent::Mode::Normal)
    else
      Subsequent::TrelloClient.create_checklist_item(checklist:, name: text)

      state = Subsequent::Commands::FetchData.call(sort:)
      state.with(mode: self)
    end
  end
end
