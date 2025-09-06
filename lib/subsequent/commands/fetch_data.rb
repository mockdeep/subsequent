# frozen_string_literal: true

# fetch data from the Trello API
module Subsequent::Commands::FetchData
  class << self
    # fetch data from the Trello API
    def call(filter:, sort:)
      cards = Subsequent::TrelloClient.fetch_cards

      # hacks to get around derived data in memory
      # clear the tags so they can be reloaded
      # and update the filter tag to the new instance
      Subsequent::Models::Tag.clear
      cards.each(&:tags) # force tags to be loaded
      if filter.is_a?(Subsequent::Filters::Tag)
        filter.tag = Subsequent::Models::Tag.find_or_create(filter.tag.name)
      end

      Subsequent::State.new(cards:, filter:, sort:)
    end
  end
end
