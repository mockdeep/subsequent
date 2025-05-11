# frozen_string_literal: true

# archive card and re-fetch data
module Subsequent::Commands::ArchiveCard
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  # archive card and re-fetch data
  def self.call(state)
    state => { card:, filter:, sort: }

    output.print("#{red("Archive this card?")} (y/n) ")
    char = input.getch

    return state unless char == "y"

    show_spinner do
      Subsequent::TrelloClient.update_card(card, closed: true)
      Subsequent::Commands::FetchData.call(filter:, sort:)
    end
  end
end
