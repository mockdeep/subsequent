# frozen_string_literal: true

# remove filters
module Subsequent::Options::RemoveFilters
  Subsequent::Options.register(self, :remove_filters)

  extend Subsequent::DisplayHelpers

  class << self
    # return true if the text is "n"
    def match?(_state, text)
      text == "n"
    end

    # remove filters
    def call(state, _text)
      filter = Subsequent::Filters::None
      Subsequent::Commands::FetchData.call(filter:, sort: state.sort)
    end
  end
end
