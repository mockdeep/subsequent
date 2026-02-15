# frozen_string_literal: true

RSpec.describe Subsequent::Options::CycleCard do
  describe ".match?" do
    it "returns true when text is c" do
      expect(described_class.match?(make_state, "c")).to be(true)
    end

    it "returns false when text is not c" do
      expect(described_class.match?(make_state, "x")).to be(false)
    end
  end

  describe ".call" do
    it "updates the card position via API" do
      stub_request(:put, /cards/).to_return(body: api_card.to_json)
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)

      described_class.call(make_state(cards: [make_card_with_item]), "c")

      expect(a_request(:put, /cards/)).to have_been_made.once
    end
  end
end
