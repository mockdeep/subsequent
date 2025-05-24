# frozen_string_literal: true

# module to encapsulate options
module Subsequent::Options
  class << self
    # add option to the list of registered options
    def register(option, symbol)
      @registered_options ||= {}
      @registered_options[symbol] = option
    end

    # return array of registered options based on the given symbols
    def fetch(*symbols)
      symbols.map { |symbol| @registered_options.fetch(symbol) }
    end
  end
end

require_relative "options/add_card"
require_relative "options/add_checklist"
require_relative "options/add_checklist_item"
require_relative "options/add_filter"
require_relative "options/add_item_mode"
require_relative "options/archive_card"
require_relative "options/cancel"
require_relative "options/create_card"
require_relative "options/create_checklist"
require_relative "options/create_checklist_item"
require_relative "options/cycle_card"
require_relative "options/cycle_checklist"
require_relative "options/cycle_checklist_item"
require_relative "options/cycle_mode"
require_relative "options/exit"
require_relative "options/filter_mode"
require_relative "options/noop"
require_relative "options/open_links"
require_relative "options/refresh"
require_relative "options/remove_filters"
require_relative "options/sort"
require_relative "options/sort_mode"
require_relative "options/toggle_checklist_item"
