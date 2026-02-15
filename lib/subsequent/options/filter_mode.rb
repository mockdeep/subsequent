# frozen_string_literal: true

# switch to filter mode
module Subsequent::Options::FilterMode
  Subsequent::Options.register(self, :filter_mode)

  class << self
    # return true if the text is "f"
    def match?(_state, text)
      text == "f"
    end

    # return state with mode set to filter
    def call(state, _text)
      state.with(mode: Subsequent::Modes::Filter, tag_page: 0)
    end
  end
end
