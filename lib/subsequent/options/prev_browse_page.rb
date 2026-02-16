# frozen_string_literal: true

# go back to the previous browse page
module Subsequent::Options::PrevBrowsePage
  Subsequent::Options.register(self, :prev_browse_page)

  class << self
    # return true if text is "<" and not on the first page
    def match?(state, text)
      text == "<" && state.browse_page.positive?
    end

    # return state with decremented browse page
    def call(state, _text)
      state.with(browse_page: state.browse_page - 1)
    end
  end
end
