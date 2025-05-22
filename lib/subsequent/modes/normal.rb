# frozen_string_literal: true

# Normal mode functionality
module Subsequent::Modes::Normal
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  OPTIONS = [
    Subsequent::Options::ToggleChecklistItem,
    Subsequent::Options::Refresh,
    Subsequent::Options::FilterMode,
    Subsequent::Options::SortMode,
    Subsequent::Options::CycleMode,
    Subsequent::Options::AddItemMode,
    Subsequent::Options::OpenLinks,
    Subsequent::Options::ArchiveCard,
    Subsequent::Options::Exit,
    Subsequent::Options::Noop,
  ].freeze

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
    text = input.getch

    OPTIONS.find { |option| option.match?(state, text) }.call(state, text)
  end
end
