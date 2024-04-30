RSpec.describe Subsequent::TrelloClient do
  describe ".fetch_next_card" do
    it "returns the next card" do
      stub_request(:get, /api.trello.com\/1\/lists/)
        .to_return(body: [{ id: "123", name: "blah" }].to_json)
      stub_request(:get, /api.trello.com\/1\/cards\/123\/checklists/)
        .to_return(body: [{ id: "456", name: "Checklist", pos: 1, check_items: [] }].to_json)

      card = described_class.fetch_next_card

      expect(card.name).to eq("blah")
      expect(card.checklists.size).to eq(1)
      expect(card.checklists.first.items).to eq([])
    end
  end
end
