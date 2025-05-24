# frozen_string_literal: true

# Normal mode functionality
module Subsequent::Modes::Normal
  extend Subsequent::Modes::Base
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  INPUT_METHOD = :getch

  OPTIONS = [
    :toggle_checklist_item,
    :refresh,
    :filter_mode,
    :sort_mode,
    :cycle_mode,
    :add_item_mode,
    :open_links,
    :archive_card,
    :exit,
    :noop,
  ].freeze

  class << self
    # normal mode commands
    def commands(state)
      row1 = "sort by #{gray(state.sort)}"
      row2 = checklist_item_commands(state)
      row3 =
        "(#{cyan("f")})ilter " \
        "(#{cyan("s")})ort " \
        "(#{cyan("o")})pen " \
        "(#{cyan("c")})ycle " \
        "(#{cyan("n")})ew"
      row4 = "(#{cyan("r")})efresh (#{cyan("a")})rchive (#{cyan("q")})uit"

      [row1, row2, row3, row4].compact.join("\n")
    end

    # checklist item commands
    def checklist_item_commands(state)
      state => { checklist_items: }

      return if checklist_items.empty?

      item_range = (1..checklist_items.size).to_a.map(&method(:cyan))

      "(#{item_range.join(", ")}) toggle task"
    end
  end
end
