# frozen_string_literal: true

# Normal mode functionality
module Subsequent::Modes::Normal
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  # normal mode commands
  def self.commands(state)
    row1 = "sort by #{gray(state.sort)}"
    row2 = checklist_item_commands(state)
    row3 =
      "(#{cyan("f")})ilter " \
      "(#{cyan("s")})ort " \
      "(#{cyan("o")})pen " \
      "(#{cyan("c")})ycle " \
      "(#{cyan("n")})ew"
    row4 = "(#{cyan("r")})efresh (#{cyan("a")})rchive (#{cyan("q")})uit"

    [row1, row2, row3, row4].compact
  end

  # checklist item commands
  def self.checklist_item_commands(state)
    state => { checklist_items: }

    return if checklist_items.empty?

    item_range = (1..checklist_items.size).to_a.map(&method(:cyan))

    "(#{item_range.join(", ")}) toggle task"
  end

  # handle input for normal mode
  def self.handle_input(state)
    state => { checklist_items:, filter:, sort: }

    char = input.getch

    case char
    when ("1"..checklist_items.to_a.size.to_s)
      Subsequent::Commands::ToggleChecklistItem.call(state, char)
    when "r"
      show_spinner { Subsequent::Commands::FetchData.call(filter:, sort:) }
    when "f"
      state.with(mode: Subsequent::Modes::Filter)
    when "s"
      state.with(mode: Subsequent::Modes::Sort)
    when "c"
      state.with(mode: Subsequent::Modes::Cycle)
    when "n"
      state.with(mode: Subsequent::Modes::AddItem)
    when "o"
      Subsequent::Commands::OpenLinks.call(state)
    when "a"
      Subsequent::Commands::ArchiveCard.call(state)
    when "q", "\u0004", "\u0003"
      output.puts
      output.puts yellow("Goodbye!")
      exit
    else
      state
    end
  end
end
