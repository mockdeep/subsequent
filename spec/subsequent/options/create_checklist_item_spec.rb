RSpec.describe Subsequent::Options::CreateChecklistItem, :buttress_io do
  describe '.match?' do
    it 'returns true' do
      expect(Subsequent::Options::CreateChecklistItem.match?).to eq(true)
    end
  end

  describe '.call' do
    it 'returns state.with(mode: Subsequent::Modes::AddChecklistItem)' do
      expect(Subsequent::Options::CreateChecklistItem.call(Subsequent::State.new(cards: [Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 'blah3', short_url: 'blah4', checklists: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", check_items: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", state: "blah5"}]}])], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2')).to be_an_instance_of(Subsequent::State)
      expect(a_request(:post, %r{/1/checklists/blah2/checkItems})).to have_been_made
      expect(a_request(:get, %r{/1/lists/default_list_id/cards})).to have_been_made
    end

    it 'raises Subsequent::Error' do
      stub_request(:post, %r{/1/checklists/blah2/checkItems}).to_return(status: 500)

      expect { Subsequent::Options::CreateChecklistItem.call(Subsequent::State.new(cards: [Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 'blah3', short_url: 'blah4', checklists: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", check_items: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", state: "blah5"}]}])], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2') }.to raise_error(Subsequent::Error)
    end
  end
end
