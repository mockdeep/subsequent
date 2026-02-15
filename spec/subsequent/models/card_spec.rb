# frozen_string_literal: true

RSpec.describe Subsequent::Models::Card do
  describe "#==" do
    it "returns true for same id" do
      card1 = make_card(id: 1)
      card2 = make_card(id: 1)

      expect(card1).to eq(card2)
    end

    it "returns false for different id" do
      card1 = make_card(id: 1)
      card2 = make_card(id: 2)

      expect(card1).not_to eq(card2)
    end
  end
end
