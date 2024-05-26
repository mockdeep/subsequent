# frozen_string_literal: true

# Sort mode functionality
module Subsequent::Mode::Sort
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  # sort mode commands
  def self.commands(_state)
    string = "sort cards by " \
             "(#{cyan("f")})irst " \
             "(#{cyan("l")})east/" \
             "(#{cyan("m")})ost unchecked items"

    [string, "(#{cyan("q")}) to cancel"]
  end

  # handle input for sort mode
  def self.handle_input(state)
    state => { cards: }

    char = input.getch

    case char
    when "q", "\u0004", "\u0003"
      Subsequent::State.new(**state.to_h, mode: Subsequent::Mode::Normal)
    when "f", "l", "m"
      Subsequent::State.format(cards:, sort: sort_modes.fetch(char.to_sym))
    else
      state
    end
  end

  # map character pressed to sort mode
  def self.sort_modes
    {
      f: Subsequent::Sort::First,
      m: Subsequent::Sort::MostUncheckedItems,
      l: Subsequent::Sort::LeastUncheckedItems
    }
  end
end
