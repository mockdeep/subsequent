# frozen_string_literal: true

RSpec.describe Subsequent::Filters::None do
  describe ".call" do
    it "returns the cards unchanged" do
      cards = [make_card, make_card(name: "Other Card")]

      expect(described_class.call(cards)).to eq(cards)
    end

    it "returns an empty array when given an empty array" do
      expect(described_class.call([])).to eq([])
    end
  end
end
