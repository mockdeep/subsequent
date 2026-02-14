# frozen_string_literal: true

RSpec.describe Subsequent::Sorts::MostUncheckedItems do
  describe "#to_s" do
    it 'returns "most_unchecked_items"' do
      expect(described_class.to_s).to eq("most_unchecked_items")
    end
  end

  describe "#call" do
    it "returns card with most unchecked items across checklists" do
      card1 = make_card_with_item
      card2 = make_card_with_item
      cl = card2.checklists.first
      cl.items << make_checklist_item(id: 3, pos: 2)

      expect(described_class.call([card1, card2])).to eq(card2)
    end
  end
end
