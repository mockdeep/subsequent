# frozen_string_literal: true

# remove filters
module Subsequent::Options::RemoveFilters
  extend Subsequent::DisplayHelpers

  # return true if the text is "n"
  def self.match?(_state, text)
    text == "n"
  end

  # remove filters
  def self.call(state, _text)
    filter = Subsequent::Filters::None
    Subsequent::Commands::FetchData.call(filter:, sort: state.sort)
  end
end
