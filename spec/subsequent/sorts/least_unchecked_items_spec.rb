# frozen_string_literal: true

RSpec.describe Subsequent::Sorts::LeastUncheckedItems do
  describe "#to_s" do
    it 'returns "least_unchecked_items"' do
      expect(described_class.to_s).to eq("least_unchecked_items")
    end
  end

  describe "#call" do
    it "returns card with fewest unchecked items" do
      card1 = make_card_with_item
      card1.checklists.first.items << make_checklist_item(id: 2, pos: 2)
      card2 = make_card_with_item

      expect(described_class.call([card1, card2])).to eq(card2)
    end
  end
end
