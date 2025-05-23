# frozen_string_literal: true

# cycle card to the end
module Subsequent::Options::CycleCard
  extend Subsequent::DisplayHelpers
  class << self
    # return true if the text is "c"
    def match?(_state, text)
      text == "c"
    end

    # cycle card to the end and fetch data
    def call(state, _text)
      state => { cards:, card:, filter:, sort: }

      pos = cards.last.pos + 1

      show_spinner do
        Subsequent::TrelloClient.update_card(card, pos:)
        Subsequent::Commands::FetchData.call(filter:, sort:)
      end
    end
  end
end
