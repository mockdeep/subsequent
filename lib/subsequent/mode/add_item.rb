# frozen_string_literal: true

# Add item mode functionality
module Subsequent::Mode::AddItem
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  # add item mode commands
  def self.commands(state)
    state => { checklist: }

    string =
      if checklist.present?
        "add new (#{cyan("c")})ard, check(#{cyan("l")})ist or (#{cyan("i")})tem"
      else
        "add new (#{cyan("c")})ard or check(#{cyan("l")})ist"
      end

    [string, "(#{cyan("q")}) to cancel"]
  end

  # handle input for add item mode
  def self.handle_input(state)
    case input.getch
    when "q", "\u0004", "\u0003"
      state.with(mode: Subsequent::Mode::Normal)
    when "c"
      state.with(mode: Subsequent::Mode::AddCard)
    when "l"
      state.with(mode: Subsequent::Mode::AddChecklist)
    when "i"
      return state unless state.checklist.present?

      state.with(mode: Subsequent::Mode::AddChecklistItem)
    else
      state
    end
  end
end
