# frozen_string_literal: true

# open links
module Subsequent::Options::OpenLinks
  # return true if the text is "o"
  def self.match?(_state, text)
    text == "o"
  end

  # open links
  def self.call(state, _text)
    Subsequent::Commands::OpenLinks.call(state)
  end
end
