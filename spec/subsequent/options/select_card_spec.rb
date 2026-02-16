# frozen_string_literal: true

RSpec.describe Subsequent::Options::SelectCard do
  describe ".match?" do
    it "returns true when text is a number in card range" do
      state = make_state(cards: [make_card])

      expect(described_class.match?(state, "1")).to be(true)
    end

    it "returns false when text is out of card range" do
      state = make_state(cards: [make_card])

      expect(described_class.match?(state, "5")).to be(false)
    end

    it "returns false when no cards" do
      state = make_state(cards: [])

      expect(described_class.match?(state, "1")).to be(false)
    end

    it "returns false when text is not a number" do
      state = make_state(cards: [make_card])

      expect(described_class.match?(state, "x")).to be(false)
    end
  end

  describe ".call" do
    it "transitions to SelectChecklist mode" do
      card = make_card(checklists: [api_checklist])
      state = make_state(cards: [card])

      result = described_class.call(state, "1")

      expect(result.mode).to eq(Subsequent::Modes::SelectChecklist)
    end

    it "sets the selected card" do
      card = make_card(checklists: [api_checklist])
      state = make_state(cards: [card])

      expect(described_class.call(state, "1").card).to eq(card)
    end

    it "resets browse_page to 0" do
      card = make_card(checklists: [api_checklist])
      state = make_state(cards: [card])

      expect(described_class.call(state, "1").browse_page).to eq(0)
    end

    it "offsets index by page" do
      cards = 10.times.map { |i| make_card(id: i, name: "C#{i}") }
      state = make_state(cards:, browse_page: 1)

      expect(described_class.call(state, "1").card.name).to eq("C9")
    end
  end
end
