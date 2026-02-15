# frozen_string_literal: true

RSpec.describe Subsequent::Sorts::LeastUncheckedItems do
  describe "#to_s" do
    it 'returns "least_unchecked_items"' do
      expect(described_class.to_s).to eq("least_unchecked_items")
    end
  end

  def card_with_items(*item_overrides)
    items = item_overrides.map { |o| api_item(**o) }
    make_card(checklists: [api_checklist(check_items: items)])
  end

  describe "#call" do
    it "returns card with fewest unchecked items" do
      card1 = card_with_items({ id: 1 }, { id: 2, pos: 2 })
      card2 = make_card_with_item

      expect(described_class.call([card1, card2])).to eq(card2)
    end

    it "returns nil for an empty array" do
      expect(described_class.call([])).to be_nil
    end

    it "returns the card when given a single card" do
      card = make_card_with_item

      expect(described_class.call([card])).to eq(card)
    end
  end
end
