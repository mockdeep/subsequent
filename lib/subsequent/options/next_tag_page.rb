# frozen_string_literal: true

# advance to the next page of tags
module Subsequent::Options::NextTagPage
  Subsequent::Options.register(self, :next_tag_page)

  class << self
    # return true if text is ">" and more pages exist
    def match?(state, text)
      text == ">" && state.tag_page < state.tags.each_slice(9).count - 1
    end

    # return state with incremented tag page
    def call(state, _text)
      state.with(tag_page: state.tag_page + 1)
    end
  end
end
