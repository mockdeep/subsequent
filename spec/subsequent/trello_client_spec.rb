RSpec.describe Subsequent::TrelloClient do
  def api_checklist
    { id: "456", name: "Checklist", pos: 1, check_items: [] }
  end

  def api_card
    { id: "123", name: "blah", short_url: "http://example.com" }
  end

  def test_cards_url
    "https://api.trello.com/1/lists/test-list-id/cards?key=test-key&token=test-token"
  end

  def test_checklists_url
    "https://api.trello.com/1/cards/123/checklists?key=test-key&token=test-token"
  end

  describe ".fetch_next_card" do
    it "returns the next card" do
      stub_request(:get, test_cards_url).to_return(body: [api_card].to_json)
      stub_request(:get, test_checklists_url)
        .to_return(body: [api_checklist].to_json)

      card = described_class.fetch_next_card

      expect(card.name).to eq("blah")
      expect(card.checklists.size).to eq(1)
      expect(card.checklists.first.items).to eq([])
    end
  end
end
