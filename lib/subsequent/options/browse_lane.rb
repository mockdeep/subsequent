# frozen_string_literal: true

# browse lanes (Trello lists)
module Subsequent::Options::BrowseLane
  Subsequent::Options.register(self, :browse_lane)

  extend Subsequent::DisplayHelpers

  class << self
    # return true if the text is "l"
    def match?(_state, text)
      text == "l"
    end

    # fetch lists and enter SelectList mode
    def call(state, _text)
      show_spinner { Subsequent::Commands::FetchLists.call(state) }
    end
  end
end
