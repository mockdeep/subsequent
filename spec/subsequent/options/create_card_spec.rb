RSpec.describe Subsequent::Options::CreateCard, :buttress_io do
  describe '.match?' do
    it 'returns true' do
      expect(Subsequent::Options::CreateCard.match?).to eq(true)
    end
  end

  describe '.call' do
    it 'returns state.with(mode: Subsequent::Modes::AddChecklist)' do
      stub_request(:post, %r{/1/cards}).to_return(status: 200, body: "[{\"id\":\"blah1\",\"name\":\"blah2\",\"pos\":\"blah3\",\"short_url\":\"blah4\",\"checklists\":[]}]")
      stub_request(:get, %r{/1/lists/default_list_id/cards}).to_return(status: 200, body: "[{\"id\":\"blah1\",\"name\":\"blah2\",\"pos\":\"blah3\",\"short_url\":\"blah4\",\"checklists\":[]}]")

      expect(Subsequent::Options::CreateCard.call(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2')).to eq(Subsequent::State.new(browsed_checklist: false, browse_list_id: nil, browse_page: 0, cards: [Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 'blah3', short_url: 'blah4', checklists: [])], card: Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 'blah3', short_url: 'blah4', checklists: []), checklist: Subsequent::Models::NullChecklist.new, checklist_items: [], filter: Subsequent::Filters::None, lists: [], mode: Subsequent::Modes::AddChecklist, sort: Subsequent::Sorts::First, tag_page: 0))
      expect(a_request(:post, %r{/1/cards})).to have_been_made
      expect(a_request(:get, %r{/1/lists/default_list_id/cards})).to have_been_made
    end

    it 'raises Subsequent::Error' do
      stub_request(:post, %r{/1/cards}).to_return(status: 500)

      expect { Subsequent::Options::CreateCard.call(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2') }.to raise_error(Subsequent::Error)
    end
  end
end
