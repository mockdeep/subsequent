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
    state => { cards:, filter: }

    char = input.getch

    case char
    when "q", "\u0004", "\u0003"
      state.with(mode: Subsequent::Mode::Normal)
    when "f", "l", "m"
      Subsequent::State.format(cards:, filter:, sort: sort_mode(char))
    else
      state
    end
  end

  # map character pressed to sort mode
  def self.sort_mode(char)
    {
      f: Subsequent::Sorts::First,
      m: Subsequent::Sorts::MostUncheckedItems,
      l: Subsequent::Sorts::LeastUncheckedItems,
    }.fetch(char.to_sym)
  end
end
