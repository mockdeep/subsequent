# frozen_string_literal: true

RSpec.describe Subsequent::Commands::OpenLinks do
  describe ".call" do
    before do
      allow(described_class).to receive(:system)
      allow(described_class).to receive(:sleep)
    end

    it "opens links found in checklist items" do
      card = make_card
      checklist = make_checklist
      item = make_checklist_item(name: "visit https://example.com")
      card.checklists << checklist
      checklist.items << item
      state = make_state(cards: [card])

      described_class.call(state)

      expect(described_class)
        .to have_received(:system).with("open", "https://example.com")
    end

    it "falls back to card's short_url when no links in items" do
      state = make_state

      described_class.call(state)

      expect(described_class)
        .to have_received(:system).with("open", "http://example.com")
    end

    it "opens multiple links with sleep between each" do
      card = make_card
      checklist = make_checklist
      item = make_checklist_item(
        name: "https://example.com https://example.org",
      )
      card.checklists << checklist
      checklist.items << item
      state = make_state(cards: [card])

      described_class.call(state)

      expect(described_class)
        .to have_received(:system).with("open", "https://example.com").ordered
      expect(described_class)
        .to have_received(:system).with("open", "https://example.org").ordered
      expect(described_class).to have_received(:sleep).with(0.1).twice
    end

    it "returns the original state" do
      state = make_state

      result = described_class.call(state)

      expect(result).to eq(state)
    end
  end
end
