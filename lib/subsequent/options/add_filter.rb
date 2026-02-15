# frozen_string_literal: true

# add filter to the current state
module Subsequent::Options::AddFilter
  Subsequent::Options.register(self, :add_filter)

  extend Subsequent::DisplayHelpers

  class << self
    # return true if the text is a number in the current page's tag range
    def match?(state, text)
      page_size = page_tags(state).size
      return false if page_size.zero?

      ("1"..page_size.to_s).to_a.include?(text)
    end

    # add filter to the current state
    def call(state, text)
      index = (state.tag_page * 9) + Integer(text) - 1
      tag = state.tags.fetch(index)
      filter = Subsequent::Filters::Tag.new(tag.name)
      Subsequent::Commands::FetchData.call(filter:, sort: state.sort)
    end

    private

    def page_tags(state)
      state.tags.each_slice(9).to_a.fetch(state.tag_page, [])
    end
  end
end
