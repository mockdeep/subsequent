# frozen_string_literal: true

# archive card
module Subsequent::Options::ArchiveCard
  # return true if the text is "a"
  def self.match?(_state, text)
    text == "a"
  end

  # archive the card
  def self.call(state, _text)
    Subsequent::Commands::ArchiveCard.call(state)
  end
end
