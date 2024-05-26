# frozen_string_literal: true

# Cycle mode functionality
module Subsequent::Mode::Cycle
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  # cycle mode commands
  def self.commands(state)
    state => { checklist:, checklist_items: }

    string = [
      "move first",
      checklist_items && "(#{cyan("i")})tem,",
      checklist && "(#{cyan("l")})ist or",
      "(#{cyan("c")})ard to the end"
    ].compact.join(" ")

    [string, "(#{cyan("q")}) to cancel"]
  end

  # handle input for cycle mode
  def self.handle_input(state)
    case input.getch
    when "q", "\u0004", "\u0003"
      Subsequent::State.new(**state.to_h, mode: :normal)
    when "i"
      cycle_checklist_item(state)
    when "l"
      cycle_checklist(state)
    when "c"
      cycle_card(state)
    else
      state
    end
  end

  # cycle checklist item to the end
  def self.cycle_checklist_item(state)
    state => { checklist:, checklist_items:, sort: }

    checklist_item = checklist_items.first
    pos = checklist.items.last.pos + 1
    show_spinner do
      Subsequent::TrelloClient.update_checklist_item(checklist_item, pos:)
      Subsequent::Commands::FetchData.call(sort:)
    end
  end

  # cycle checklist to the end
  def self.cycle_checklist(state)
    state => { card:, checklist:, sort: }

    pos = card.checklists.last.pos + 1

    show_spinner do
      Subsequent::TrelloClient.update_checklist(checklist, pos:)
      Subsequent::Commands::FetchData.call(sort:)
    end
  end

  # cycle card to the end
  def self.cycle_card(state)
    state => { cards:, card:, sort: }

    pos = cards.last.pos + 1

    show_spinner do
      Subsequent::TrelloClient.update_card(card, pos:)
      Subsequent::Commands::FetchData.call(sort:)
    end
  end
end
