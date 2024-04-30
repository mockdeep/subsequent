module Subsequent::TrelloClient
  YAML_LOAD_OPTIONS = { permitted_classes: [Symbol], symbolize_names: true }

  class << self
    def fetch_next_card
      data = fetch_cards(config.fetch(:trello_list_id))

      Subsequent::Models::Card.new(**data.first)
    end

    def fetch_checklists(card_id)
      fetch_data("cards/#{card_id}/checklists").sort_by do |checklist_data|
        checklist_data.fetch(:pos)
      end
    end

    def toggle_checklist_item(item)
      state = item.checked? ? "incomplete" : "complete"
      item.state = state
      path = "cards/#{item.card_id}/checkItem/#{item.id}"

      response = HTTP.put(trello_api_url(path, state:))

      unless response.status.success?
        raise Subsequent::Error, "Failed to toggle checklist item"
      end
    end

    def config_path=(path)
      @config = nil
      @config_path = path
    end

    def config_path
      @config_path ||= File.join(Dir.home, ".subsequent/config.yml")
    end

    private

    def fetch_cards(list_id)
      fetch_data("lists/#{list_id}/cards")
    end

    def auth_params
      {
        key: config.fetch(:trello_key),
        token: config.fetch(:trello_token),
      }
    end

    def trello_api_url(path, **params)
      params.merge!(auth_params)

      "https://api.trello.com/1/#{path}?#{params.to_query}"
    end

    def fetch_data(path)
      response = HTTP.get(trello_api_url(path))

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
