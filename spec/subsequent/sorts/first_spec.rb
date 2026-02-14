# frozen_string_literal: true

RSpec.describe Subsequent::Sorts::First do
  describe "#to_s" do
    it 'returns "first"' do
      expect(described_class.to_s).to eq("first")
    end
  end

  describe "#call" do
    it "returns the first card" do
      card1 = make_card(id: 1)
      card2 = make_card(id: 2)

      expect(described_class.call([card1, card2])).to eq(card1)
    end

    it "returns nil for empty array" do
      expect(described_class.call([])).to be_nil
    end
  end
end
