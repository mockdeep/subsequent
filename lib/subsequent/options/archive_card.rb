# frozen_string_literal: true

# archive card
module Subsequent::Options::ArchiveCard
  class << self
    # return true if the text is "a"
    def match?(_state, text)
      text == "a"
    end

    # archive the card
    def call(state, _text)
      Subsequent::Commands::ArchiveCard.call(state)
    end
  end
end
