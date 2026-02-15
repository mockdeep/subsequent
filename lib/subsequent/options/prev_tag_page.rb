# frozen_string_literal: true

# go back to the previous page of tags
module Subsequent::Options::PrevTagPage
  Subsequent::Options.register(self, :prev_tag_page)

  class << self
    # return true if text is "<" and not on the first page
    def match?(state, text)
      text == "<" && state.tag_page.positive?
    end

    # return state with decremented tag page
    def call(state, _text)
      state.with(tag_page: state.tag_page - 1)
    end
  end
end
