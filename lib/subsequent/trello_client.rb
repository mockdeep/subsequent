# frozen_string_literal: true

# module for interacting with the Trello API
module Subsequent::TrelloClient
  YAML_LOAD_OPTIONS = {
    permitted_classes: [Symbol],
    symbolize_names: true,
  }.freeze

  class << self
    # Fetches all cards from the Trello list
    def fetch_cards
      path = "lists/#{list_id}/cards"

      cards_data = fetch_data(path, checklists: "all")

      cards_data.map { |data| Subsequent::Models::Card.new(**data) }
    end

    # updates the checklist item on Trello
    def update_checklist_item(checklist_item, **params)
      path = "cards/#{checklist_item.card_id}/checkItem/#{checklist_item.id}"
      response = HTTP.put(trello_api_url(path, **params))

      return if response.status.success?

      raise Subsequent::Error, "Failed to update checklist item"
    end

    # creates a new card on Trello
    def create_card(name:)
      path = "cards"
      response =
        HTTP.post(trello_api_url(path, name:, idList: list_id, pos: "top"))

      return if response.status.success?

      raise Subsequent::Error, "Failed to create card"
    end

    # creates a new checklist on Trello
    def create_checklist(card:, name:)
      path = "checklists"
      response =
        HTTP.post(trello_api_url(path, name:, idCard: card.id, pos: "top"))

      return if response.status.success?

      raise Subsequent::Error, "Failed to create card"
    end

    # updates the checklist on Trello
    def update_checklist(checklist, **params)
      path = "checklist/#{checklist.id}"
      response = HTTP.put(trello_api_url(path, **params))

      return if response.status.success?

      raise Subsequent::Error, "Failed to update checklist"
    end

    # updates the card on Trello
    def update_card(card, **params)
      path = "cards/#{card.id}"
      response = HTTP.put(trello_api_url(path, **params))

      return if response.status.success?

      raise Subsequent::Error, "Failed to update card"
    end

    # creates a new checklist item on Trello
    def create_checklist_item(checklist:, name:)
      path = "checklists/#{checklist.id}/checkItems"
      response = HTTP.post(trello_api_url(path, name:, pos: "top"))

      return if response.status.success?

      raise Subsequent::Error, "Failed to create checklist item"
    end

    # toggles the checklist item completion state on Trello
    def toggle_checklist_item(item)
      state = item.checked? ? "incomplete" : "complete"
      item.state = state
      path = "cards/#{item.card_id}/checkItem/#{item.id}"

      response = HTTP.put(trello_api_url(path, state:))

      return if response.status.success?

      raise Subsequent::Error, "Failed to toggle checklist item"
    end

    # sets the path to load configuration from
    def config_path=(path)
      @config = nil
      @config_path = path
    end

    # returns the path to load configuration from
    def config_path
      @config_path ||= File.join(Dir.home, ".subsequent/config.yml")
    end

    # returns the Trello API URL for a given path and params
    def trello_api_url(path, **params)
      params.merge!(auth_params)

      "https://api.trello.com/1/#{path}?#{params.to_query}"
    end

    private

    def auth_params
      {
        key: config.fetch(:trello_key),
        token: config.fetch(:trello_token),
      }
    end

    def list_id
      config.fetch(:trello_list_id)
    end

    def fetch_data(path, **params)
      response = HTTP.get(trello_api_url(path, **params))

      unless response.status.success?
        raise Subsequent::Error, "Failed to fetch data from Trello"
      end

      result = JSON.parse(response.to_s)

      if result.is_a?(Array)
        result.map { |item| transform_keys(item) }
      else
        transform_keys(result)
      end
    end

    def transform_keys(hash)
      hash.deep_transform_keys { |key| key.underscore.to_sym }
    end

    def config
      @config ||= YAML.safe_load_file(config_path, **YAML_LOAD_OPTIONS)
    end
  end
end
