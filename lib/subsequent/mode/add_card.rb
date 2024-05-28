# frozen_string_literal: true

# Add card mode functionality
module Subsequent::Mode::AddCard
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
      Subsequent::State.new(**state.to_h, mode: Subsequent::Mode::Normal)
    else
      Subsequent::TrelloClient.create_card(name: text)
      mode = Subsequent::Mode::AddChecklist
      state = Subsequent::Commands::FetchData.call(sort: state.sort)

      Subsequent::State.new(**state.to_h, mode:)
    end
  end
end
