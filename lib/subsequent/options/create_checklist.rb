# frozen_string_literal: true

# create a new checklist in Trello
module Subsequent::Options::CreateChecklist
  # return true, default to this when no other option matches
  def self.match?(*)
    true
  end

  # create a new checklist in Trello and re-fetch data
  def self.call(state, text)
    Subsequent::Commands::CreateChecklist.call(state, text)
  end
end
