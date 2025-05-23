# frozen_string_literal: true

# open links
module Subsequent::Options::OpenLinks
  class << self
    # return true if the text is "o"
    def match?(_state, text)
      text == "o"
    end

    # open links
    def call(state, _text)
      Subsequent::Commands::OpenLinks.call(state)
    end
  end
end
