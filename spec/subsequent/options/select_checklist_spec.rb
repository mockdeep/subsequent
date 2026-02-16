# frozen_string_literal: true

RSpec.describe Subsequent::Options::SelectChecklist do
  def many_active_checklists
    10.times.map do |i|
      api_checklist(id: i.to_s, name: "CL#{i}", check_items: [api_item])
    end
  end

  def card_with_checklist(**overrides)
    defaults = { check_items: [api_item] }
    make_card(checklists: [api_checklist(**defaults, **overrides)])
  end

  describe ".match?" do
    it "returns true when text is a number in checklist range" do
      state = make_state(cards: [card_with_checklist])

      expect(described_class.match?(state, "1")).to be(true)
    end

    it "returns false when text is out of checklist range" do
      state = make_state(cards: [card_with_checklist])

      expect(described_class.match?(state, "5")).to be(false)
    end

    it "returns false when no checklists" do
      state = make_state(cards: [])

      expect(described_class.match?(state, "1")).to be(false)
    end

    it "returns false when text is not a number" do
      state = make_state(cards: [card_with_checklist])

      expect(described_class.match?(state, "x")).to be(false)
    end
  end

  describe ".call" do
    it "transitions to Normal mode" do
      state = make_state(cards: [card_with_checklist])

      result = described_class.call(state, "1")

      expect(result.mode).to eq(Subsequent::Modes::Normal)
    end

    it "sets the selected checklist" do
      state = make_state(cards: [card_with_checklist])

      expect(described_class.call(state, "1").checklist.name).to eq("Checklist")
    end

    it "populates checklist items" do
      state = make_state(cards: [card_with_checklist])

      expect(described_class.call(state, "1").checklist_items.size).to eq(1)
    end

    it "limits checklist items to first 5" do
      items = 6.times.map { |i| api_item(id: i, pos: i) }
      card = card_with_checklist(check_items: items)
      state = make_state(cards: [card])

      expect(described_class.call(state, "1").checklist_items.size).to eq(5)
    end

    it "offsets index by page" do
      card = make_card(checklists: many_active_checklists)
      state = make_state(cards: [card], browse_page: 1)

      expect(described_class.call(state, "1").checklist.name).to eq("CL9")
    end
  end
end
