# frozen_string_literal: true

# switch to browse mode
module Subsequent::Options::BrowseMode
  Subsequent::Options.register(self, :browse_mode)

  extend Subsequent::DisplayHelpers

  class << self
    # return true if the text is "b"
    def match?(_state, text)
      text == "b"
    end

    # fetch lists and enter browse mode
    def call(state, _text)
      show_spinner { Subsequent::Commands::FetchLists.call(state) }
    end
  end
end
