RSpec.describe Subsequent::Models::Card do
  describe '#checklists' do
    it 'returns @checklists' do
      card = Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 'blah3', short_url: 'blah4', checklists: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", check_items: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", state: "blah5"}]}])

      expect(card.checklists).to eq([Subsequent::Models::Checklist.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4', check_items: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", state: "blah5"}])])
    end
  end
end
