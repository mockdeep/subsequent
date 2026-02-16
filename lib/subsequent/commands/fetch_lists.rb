# frozen_string_literal: true

# fetch lists from the Trello API
module Subsequent::Commands::FetchLists
  class << self
    # fetch lists from the Trello API
    def call(state)
      lists = Subsequent::TrelloClient.fetch_lists

      state.with(lists:, mode: Subsequent::Modes::SelectList, browse_page: 0)
    end
  end
end
