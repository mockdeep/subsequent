# frozen_string_literal: true

# Normal mode functionality
module Subsequent::Mode::Normal
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  # normal mode commands
  def self.commands(state)
    [
      "sort by #{gray(state.sort)}",
      checklist_item_commands(state),
      "(#{cyan("r")})efresh " \
      "(#{cyan("s")})ort " \
      "(#{cyan("c")})ycle " \
      "(#{cyan("o")})pen-links " \
      "(#{cyan("a")})rchive " \
      "(#{cyan("q")})uit",
    ].compact
  end

  # checklist item commands
  def self.checklist_item_commands(state)
    state => { checklist_items: }

    return unless checklist_items

    item_range = (1..checklist_items.size).to_a.map(&method(:cyan))

    "(#{item_range.join(", ")}) toggle task"
  end

  # handle input for normal mode
  def self.handle_input(state)
    state => { checklist_items:, sort: }

    char = input.getch

    case char
    when ("1"..checklist_items.to_a.size.to_s)
      Subsequent::Commands::ToggleChecklistItem.call(state, char)
    when "r"
      show_spinner { Subsequent::Commands::FetchData.call(sort:) }
    when "s"
      Subsequent::State.new(**state.to_h, mode: Subsequent::Mode::Sort)
    when "c"
      Subsequent::State.new(**state.to_h, mode: Subsequent::Mode::Cycle)
    when "o"
      Subsequent::Commands::OpenLinks.call(state)
    when "a"
      Subsequent::Commands::ArchiveCard.call(state)
    when "q", "\u0004", "\u0003"
      output.puts yellow("Goodbye!")
      exit
    else
      state
    end
  end
end
