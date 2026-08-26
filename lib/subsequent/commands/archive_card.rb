# frozen_string_literal: true

# archive card and re-fetch data
module Subsequent::Commands::ArchiveCard
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  class << self
    # archive card and re-fetch data
    def call(state)
      state => { card: }

      output.print("#{red("Archive this card?")} (y/n) ")
      char = input.getch

      return state unless char == "y"

      show_spinner do
        Subsequent::TrelloClient.update_card(card, closed: true)
        Subsequent::Commands::FetchData.call(state)
      end
    end
  end
end
