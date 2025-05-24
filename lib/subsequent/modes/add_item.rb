# frozen_string_literal: true

# Add item mode functionality
module Subsequent::Modes::AddItem
  extend Subsequent::Modes::Base
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  INPUT_METHOD = :getch

  OPTIONS = [
    Subsequent::Options::Cancel,
    Subsequent::Options::AddCard,
    Subsequent::Options::AddChecklist,
    Subsequent::Options::AddChecklistItem,
    Subsequent::Options::Noop,
  ].freeze

  class << self
    # add item mode commands
    def commands(state)
      state => { checklist: }

      string =
        if checklist.present?
          "add new (#{cyan("c")})ard, check(#{cyan("l")})ist " \
            "or (#{cyan("i")})tem"
        else
          "add new (#{cyan("c")})ard or check(#{cyan("l")})ist"
        end

      [string, "(#{cyan("q")}) to cancel"].join("\n")
    end
  end
end
