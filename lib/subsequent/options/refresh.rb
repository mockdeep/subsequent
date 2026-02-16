# frozen_string_literal: true

# refresh the data
module Subsequent::Options::Refresh
  Subsequent::Options.register(self, :refresh)

  extend Subsequent::DisplayHelpers

  class << self
    # return true if the text is "r"
    def match?(_state, text)
      text == "r"
    end

    # refresh the data
    def call(state, _text)
      state => { filter:, sort:, browse_list_id:, lists: }

      show_spinner do
        Subsequent::Commands::FetchData.call(
          filter:, sort:, list_id: browse_list_id, lists:,
        )
      end
    end
  end
end
