# frozen_string_literal: true

RSpec.describe Subsequent::TrelloClient do
  def test_cards_url
    api_url("lists/test-list-id/cards", checklists: "all")
  end

  describe ".fetch_cards" do
    it "returns the cards" do
      stub_request(:get, test_cards_url).to_return(body: [api_card].to_json)

      cards = described_class.fetch_cards

      expect(cards.size).to eq(1)
      card = cards.first

      expect(card.name).to eq("blah")
      expect(card.checklists.size).to eq(1)
      expect(card.checklists.first.items).to eq([])
    end

    it "raises an error when the request fails" do
      stub_request(:get, test_cards_url).to_return(status: 400)

      expect { described_class.fetch_cards }
        .to raise_error(Subsequent::Error, "Failed to fetch data from Trello")
    end

    it "fetches cards from a specific list" do
      url = api_url("lists/other-list/cards", checklists: "all")
      stub_request(:get, url).to_return(body: [api_card].to_json)

      cards = described_class.fetch_cards(list_id: "other-list")

      expect(cards.size).to eq(1)
      expect(cards.first.name).to eq("blah")
    end
  end

  describe ".fetch_lists" do
    def test_lists_url
      api_url("boards/test-board-id/lists", filter: "open")
    end

    it "returns the lists" do
      stub_request(:get, test_lists_url).to_return(body: [api_list].to_json)

      lists = described_class.fetch_lists

      expect(lists.size).to eq(1)
      expect(lists.first.name).to eq("List One")
    end

    it "raises an error when the request fails" do
      stub_request(:get, test_lists_url).to_return(status: 400)

      expect { described_class.fetch_lists }
        .to raise_error(Subsequent::Error, "Failed to fetch data from Trello")
    end
  end

  describe ".update_checklist_item" do
    it "returns when the request is successful" do
      checklist_item = make_checklist_item

      path = "cards/#{checklist_item.card_id}/checkItem/#{checklist_item.id}"
      stub_request(:put, /#{path}/).to_return(status: 200)

      expect { described_class.update_checklist_item(checklist_item, pos: 4) }
        .not_to raise_error
    end

    it "raises an error when the request fails" do
      checklist_item = make_checklist_item

      path = "cards/#{checklist_item.card_id}/checkItem/#{checklist_item.id}"
      stub_request(:put, /#{path}/).to_return(status: 400)

      expect { described_class.update_checklist_item(checklist_item, pos: 4) }
        .to raise_error(Subsequent::Error, "Failed to update checklist item")
    end
  end

  describe ".create_card" do
    it "returns when the request is successful" do
      post_url =
        api_url("cards", idList: "test-list-id", name: "New Card", pos: "top")
      stub_request(:post, post_url).to_return(status: 200)

      expect { described_class.create_card(name: "New Card") }
        .not_to raise_error
    end

    it "raises an error when the request fails" do
      post_url =
        api_url("cards", idList: "test-list-id", name: "New Card", pos: "top")
      stub_request(:post, post_url).to_return(status: 400)

      expect { described_class.create_card(name: "New Card") }
        .to raise_error(Subsequent::Error, "Failed to create card")
    end
  end

  describe ".create_checklist" do
    it "returns when the request is successful" do
      name = "new checklist"
      post_url = api_url("checklists", idCard: "1", name:, pos: "top")
      stub_request(:post, post_url).to_return(status: 200)

      expect { described_class.create_checklist(card: make_card, name:) }
        .not_to raise_error
    end

    it "raises an error when the request fails" do
      name = "new checklist"
      post_url = api_url("checklists", idCard: "1", name:, pos: "top")
      stub_request(:post, post_url).to_return(status: 400)

      expect { described_class.create_checklist(card: make_card, name:) }
        .to raise_error(Subsequent::Error, "Failed to create checklist")
    end
  end

  describe ".update_checklist" do
    it "returns when the request is successful" do
      checklist = make_checklist
      path = "checklist/#{checklist.id}"
      stub_request(:put, /#{path}/).to_return(status: 200)

      expect { described_class.update_checklist(checklist, name: "new name") }
        .not_to raise_error
    end

    it "raises an error when the request fails" do
      checklist = make_checklist
      path = "checklist/#{checklist.id}"
      stub_request(:put, /#{path}/).to_return(status: 400)

      expect { described_class.update_checklist(checklist, name: "new name") }
        .to raise_error(Subsequent::Error, "Failed to update checklist")
    end
  end

  describe ".update_card" do
    it "returns when the request is successful" do
      card = make_card
      path = "cards/#{card.id}"
      stub_request(:put, /#{path}/).to_return(status: 200)

      expect { described_class.update_card(card, name: "new name") }
        .not_to raise_error
    end

    it "raises an error when the request fails" do
      card = make_card
      path = "cards/#{card.id}"
      stub_request(:put, /#{path}/).to_return(status: 400)

      expect { described_class.update_card(card, name: "new name") }
        .to raise_error(Subsequent::Error, "Failed to update card")
    end
  end

  describe ".create_checklist_item" do
    it "returns when the request is successful" do
      checklist = make_checklist
      name = "new item"

      post_url =
        api_url("checklists/#{checklist.id}/checkItems", name:, pos: "top")
      stub_request(:post, post_url).to_return(status: 200)

      expect { described_class.create_checklist_item(checklist:, name:) }
        .not_to raise_error
    end

    it "raises an error when the request fails" do
      checklist = make_checklist
      name = "new item"

      post_url =
        api_url("checklists/#{checklist.id}/checkItems", name:, pos: "top")
      stub_request(:post, post_url).to_return(status: 400)

      expect { described_class.create_checklist_item(checklist:, name:) }
        .to raise_error(Subsequent::Error, "Failed to create checklist item")
    end
  end

  describe ".toggle_checklist_item" do
    it "returns when the request is successful" do
      checklist_item = make_checklist_item
      path = "cards/#{checklist_item.card_id}/checkItem/#{checklist_item.id}"
      stub_request(:put, /#{path}/).to_return(status: 200)

      expect { described_class.toggle_checklist_item(checklist_item) }
        .not_to raise_error
    end

    it "does not mutate the item state" do
      checklist_item = make_checklist_item(state: "complete")
      path = "cards/#{checklist_item.card_id}/checkItem/#{checklist_item.id}"
      stub_request(:put, /#{path}/).to_return(status: 200)

      described_class.toggle_checklist_item(checklist_item)

      expect(checklist_item.checked?).to be(true)
    end

    it "raises an error when the request fails" do
      checklist_item = make_checklist_item
      path = "cards/#{checklist_item.card_id}/checkItem/#{checklist_item.id}"
      stub_request(:put, /#{path}/).to_return(status: 400)

      expect { described_class.toggle_checklist_item(checklist_item) }
        .to raise_error(Subsequent::Error, "Failed to toggle checklist item")
    end
  end
end
