# frozen_string_literal: true

# add filter to the current state
module Subsequent::Options::AddFilter
  Subsequent::Options.register(self, :add_filter)

  extend Subsequent::DisplayHelpers

  class << self
    # return true if the text is a number between 1 and the number of tags
    def match?(state, text)
      ("1"..state.tags.size.to_s).to_a.include?(text)
    end

    # add filter to the current state
    def call(state, text)
      tag = state.tags.fetch(Integer(text) - 1)
      filter = Subsequent::Filters::Tag.new(tag.name)
      Subsequent::Commands::FetchData.call(filter:, sort: state.sort)
    end
  end
end
