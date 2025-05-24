# frozen_string_literal: true

# create a new checklist in Trello
module Subsequent::Options::CreateChecklist
  Subsequent::Options.register(self, :create_checklist)

  class << self
    # return true, def ault to this when no other option matches
    def match?(*)
      true
    end

    # create a new checklist in Trello and re-fetch data
    def call(state, text)
      Subsequent::Commands::CreateChecklist.call(state, text)
    end
  end
end
