# frozen_string_literal: true

module TrelloHelpers
  # return the url for a given path and params
  def api_url(path, **params)
    Subsequent::TrelloClient.trello_api_url(path, **params)
  end
end

RSpec.configure do |config|
  config.include(TrelloHelpers)
end
