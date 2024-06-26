# frozen_string_literal: true

RSpec.describe Subsequent::TrelloClient do
  def make_card(**overrides)
    Subsequent::Models::Card.new(
      id: 1,
      name: "Card Name",
      pos: 1,
      description: "Card Description",
      checklists: [],
      short_url: "http://example.com",
      **overrides,
    )
  end

  def make_checklist(**overrides)
    Subsequent::Models::Checklist.new(
      card_id: 1,
      check_items: [],
      id: "456",
      name: "Checklist",
      pos: 1,
      items: [],
      **overrides,
    )
  end

  def api_checklist
    { id: "456", name: "Checklist", pos: 1, check_items: [] }
  end

  def api_card
    { id: "123", name: "blah", pos: 1, short_url: "http://example.com", checklists: [api_checklist] }
  end

  def test_cards_url
    "https://api.trello.com/1/lists/test-list-id/cards?checklists=all&key=test-key&token=test-token"
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
  end

  describe ".create_card" do
    it "raises an error when the request fails" do
      stub_request(:post, "https://api.trello.com/1/cards?idList=test-list-id&key=test-key&name=New%20Card&pos=top&token=test-token")
        .to_return(status: 400)

      expect { described_class.create_card(name: "New Card") }
        .to raise_error(Subsequent::Error, "Failed to create card")
    end
  end

  describe ".create_checklist" do
    it "raises an error when the request fails" do
      post_url = "https://api.trello.com/1/checklists?idCard=1&key=test-key&name=new%20checklist&pos=top&token=test-token"
      stub_request(:post, post_url).to_return(status: 400)
      name = "new checklist"

      expect { described_class.create_checklist(card: make_card, name:) }
        .to raise_error(Subsequent::Error, "Failed to create card")
    end
  end

  describe ".create_checklist_item" do
    it "raises an error when the request fails" do
      checklist = make_checklist
      name = "new item"

      post_url = "https://api.trello.com/1/checklists/456/checkItems?key=test-key&name=new%20item&pos=top&token=test-token"
      stub_request(:post, post_url).to_return(status: 400)

      expect { described_class.create_checklist_item(checklist:, name:) }
        .to raise_error(Subsequent::Error, "Failed to create checklist item")
    end
  end
end
