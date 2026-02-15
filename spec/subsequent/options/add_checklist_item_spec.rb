# frozen_string_literal: true

RSpec.describe Subsequent::Options::AddChecklistItem do
  describe ".match?" do
    it "returns true when text is i and checklist is present" do
      state = make_state(cards: [make_card_with_item])

      expect(described_class.match?(state, "i")).to be(true)
    end

    it "returns false when text is i but no checklist" do
      state = make_state(cards: [make_card])

      expect(described_class.match?(state, "i")).to be(false)
    end

    it "returns false when text is not i" do
      state = make_state(cards: [make_card_with_item])

      expect(described_class.match?(state, "x")).to be(false)
    end
  end

  describe ".call" do
    it "returns state with AddChecklistItem mode" do
      state = make_state(cards: [make_card_with_item])

      expect(described_class.call(state, "i"))
        .to eq(state.with(mode: Subsequent::Modes::AddChecklistItem))
    end
  end
end
