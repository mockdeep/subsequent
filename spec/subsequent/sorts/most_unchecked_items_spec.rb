# frozen_string_literal: true

RSpec.describe Subsequent::Sorts::MostUncheckedItems do
  describe "#to_s" do
    it 'returns "most_unchecked_items"' do
      expect(described_class.to_s).to eq("most_unchecked_items")
    end
  end

  def card_with_items(*item_overrides)
    items = item_overrides.map { |o| api_item(**o) }
    make_card(checklists: [api_checklist(check_items: items)])
  end

  describe "#call" do
    it "returns card with most unchecked items across checklists" do
      card1 = make_card_with_item
      card2 = card_with_items({ id: 1 }, { id: 3, pos: 2 })

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
