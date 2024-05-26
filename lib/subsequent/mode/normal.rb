# frozen_string_literal: true

# Normal mode functionality
module Subsequent::Mode::Normal
  extend Subsequent::DisplayHelpers

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
      "(#{cyan("q")})uit"
    ].compact
  end

  # checklist item commands
  def self.checklist_item_commands(state)
    state => { checklist_items: }

    return unless checklist_items

    item_range = (1..checklist_items.size).to_a.map(&method(:cyan))

    "(#{item_range.join(", ")}) toggle task"
  end
end
