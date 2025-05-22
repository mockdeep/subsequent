# frozen_string_literal: true

# refresh the data
module Subsequent::Options::Refresh
  extend Subsequent::DisplayHelpers

  # return true if the text is "r"
  def self.match?(_state, text)
    text == "r"
  end

  # refresh the data
  def self.call(state, _text)
    state => { filter:, sort: }

    show_spinner { Subsequent::Commands::FetchData.call(filter:, sort:) }
  end
end
