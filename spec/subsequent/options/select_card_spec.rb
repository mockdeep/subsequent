RSpec.describe Subsequent::Options::SelectCard do
  describe '.match?' do
    it 'returns false when page_size.zero?' do
      expect(Subsequent::Options::SelectCard.match?(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2')).to eq(false)
    end

    it 'returns ("1"..page_size.to_s).to_a.include?(text) when !(page_size.zero?)' do
      expect(Subsequent::Options::SelectCard.match?(Subsequent::State.new(cards: [Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 'blah3', short_url: 'blah4', checklists: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", check_items: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", state: "blah5"}]}])], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), '1')).to eq(true)
    end

    it 'returns ("1"..page_size.to_s).to_a.include?(text) (false) when !(page_size.zero?)' do
      expect(Subsequent::Options::SelectCard.match?(Subsequent::State.new(cards: [Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 'blah3', short_url: 'blah4', checklists: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", check_items: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", state: "blah5"}]}])], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), '')).to eq(false)
    end
  end

  describe '.call' do
    it 'returns state.with(
        card:,
        checklist:,
        checklist_items: checklist.unchecked_items.first(5),
        mode: Subsequent::Modes::Normal,
        browse_page: 0,
      )' do
      expect(Subsequent::Options::SelectCard.call(Subsequent::State.new(cards: [Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 'blah3', short_url: 'blah4', checklists: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", check_items: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", state: "blah5"}]}])], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), '1')).to eq(Subsequent::State.new(browsed_checklist: false, browse_list_id: nil, browse_page: 0, cards: [Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 'blah3', short_url: 'blah4', checklists: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", check_items: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", state: "blah5"}]}])], card: Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 'blah3', short_url: 'blah4', checklists: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", check_items: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", state: "blah5"}]}]), checklist: Subsequent::Models::Checklist.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4', check_items: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", state: "blah5"}]), checklist_items: [Subsequent::Models::ChecklistItem.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4', state: 'blah5')], filter: Subsequent::Filters::None, lists: [], mode: Subsequent::Modes::Normal, sort: Subsequent::Sorts::First, tag_page: 0))
    end
  end
end
