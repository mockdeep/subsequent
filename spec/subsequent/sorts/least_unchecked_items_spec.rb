RSpec.describe Subsequent::Sorts::LeastUncheckedItems do
  describe '.to_s' do
    it 'returns "least_unchecked_items"' do
      expect(Subsequent::Sorts::LeastUncheckedItems.to_s).to eq('least_unchecked_items')
    end
  end

  describe '.call' do
    it 'returns cards.min_by do |card|
        card.checklists.sum do |checklist|
          checklist.unchecked_items.count
        end
      end' do
      expect(Subsequent::Sorts::LeastUncheckedItems.call([Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 'blah3', short_url: 'blah4', checklists: [])])).to eq(Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 'blah3', short_url: 'blah4', checklists: []))
    end
  end
end
