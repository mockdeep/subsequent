# frozen_string_literal: true

# Add card mode functionality
module Subsequent::Modes::AddCard
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  # add card mode commands
  def self.commands(_state)
    ["enter card name (#{cyan("q")}) to cancel: "]
  end

  # handle input for add card mode
  def self.handle_input(state)
    text = input.gets.to_s.squish

    case text
    when "", "q", "\u0004", "\u0003"
      state.with(mode: Subsequent::Modes::Normal)
    else
      state => { filter:, sort: }
      Subsequent::TrelloClient.create_card(name: text)
      state = Subsequent::Commands::FetchData.call(filter:, sort:)

      state.with(mode: Subsequent::Modes::AddChecklist)
    end
  end
end
