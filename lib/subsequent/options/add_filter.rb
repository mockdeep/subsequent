# frozen_string_literal: true

# add filter to the current state
module Subsequent::Options::AddFilter
  extend Subsequent::DisplayHelpers

  # return true if the text is a number between 1 and the number of tags
  def self.match?(state, text)
    ("1"..state.tags.size.to_s).to_a.include?(text)
  end

  # add filter to the current state
  def self.call(state, text)
    filter = Subsequent::Filters::Tag.new(state.tags[Integer(text) - 1])
    Subsequent::Commands::FetchData.call(filter:, sort: state.sort)
  end
end
