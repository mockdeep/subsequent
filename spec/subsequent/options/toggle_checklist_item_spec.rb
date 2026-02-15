# frozen_string_literal: true

RSpec.describe Subsequent::Options::ToggleChecklistItem do
  describe ".match?" do
    it "returns true when text is a number in item range" do
      state = make_state(cards: [make_card_with_item])

      expect(described_class.match?(state, "1")).to be(true)
    end

    it "returns false when text is out of item range" do
      state = make_state(cards: [make_card_with_item])

      expect(described_class.match?(state, "5")).to be(false)
    end

    it "returns false when there are no checklist items" do
      expect(described_class.match?(make_state, "1")).to be(false)
    end
  end

  describe ".call" do
    it "toggles the checklist item via API" do
      state = make_state(cards: [make_card_with_item])
      stub_request(:put, /checkItem/).to_return(body: api_item.to_json)

      described_class.call(state, "1")

      expect(a_request(:put, /checkItem/)).to have_been_made.once
    end
  end
end
