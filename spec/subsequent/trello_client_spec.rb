# frozen_string_literal: true

RSpec.describe Subsequent::TrelloClient do
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
end
