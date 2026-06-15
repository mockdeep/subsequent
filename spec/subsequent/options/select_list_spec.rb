RSpec.describe Subsequent::Options::SelectList, :buttress_io do
  describe '.match?' do
    it 'returns false when page_size.zero?' do
      expect(Subsequent::Options::SelectList.match?(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2')).to eq(false)
    end

    it 'returns ("1"..page_size.to_s).to_a.include?(text) when !(page_size.zero?)' do
      expect(Subsequent::Options::SelectList.match?(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None, lists: [{id: "blah1", name: "blah2"}]), '1')).to eq(true)
    end

    it 'returns ("1"..page_size.to_s).to_a.include?(text) (false) when !(page_size.zero?)' do
      expect(Subsequent::Options::SelectList.match?(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None, lists: [{id: "blah1", name: "blah2"}]), '')).to eq(false)
    end
  end

  describe '.call' do
    it 'returns show_spinner { fetch_and_transition(state, list) }' do
      Subsequent::Configuration.debug = true
      stub_request(:get, %r{/1/lists/blah1/cards}).to_return(status: 200, body: "[{\"id\":\"blah1\",\"name\":\"blah2\",\"pos\":\"blah3\",\"short_url\":\"blah4\",\"checklists\":[]}]")

      expect(Subsequent::Options::SelectList.call(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None, lists: [Subsequent::Models::List.new(id: 'blah1', name: 'blah2')]), '1')).to eq(Subsequent::State.new(browsed_checklist: false, browse_list_id: 'blah1', browse_page: 0, cards: [Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 'blah3', short_url: 'blah4', checklists: [])], card: Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 'blah3', short_url: 'blah4', checklists: []), checklist: Subsequent::Models::NullChecklist.new, checklist_items: [], filter: Subsequent::Filters::None, lists: [Subsequent::Models::List.new(id: 'blah1', name: 'blah2')], mode: Subsequent::Modes::Normal, sort: Subsequent::Sorts::First, tag_page: 0))
      expect(a_request(:get, %r{/1/lists/blah1/cards})).to have_been_made
    end

    it 'raises Subsequent::Error' do
      Subsequent::Configuration.debug = true
      stub_request(:get, %r{/1/lists/blah1/cards}).to_return(status: 500)

      expect { Subsequent::Options::SelectList.call(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None, lists: [Subsequent::Models::List.new(id: 'blah1', name: 'blah2')]), '1') }.to raise_error(Subsequent::Error)
    end
  end
end
