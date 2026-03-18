# frozen_string_literal: true

# switch to browse mode
module Subsequent::Options::BrowseMode
  Subsequent::Options.register(self, :browse_mode)

  class << self
    # return true if the text is "b"
    def match?(_state, text)
      text == "b"
    end

    # enter browse prefix mode
    def call(state, _text)
      state.with(mode: Subsequent::Modes::Browse)
    end
  end
end
