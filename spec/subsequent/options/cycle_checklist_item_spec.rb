RSpec.describe Subsequent::Options::CycleChecklistItem, :buttress_io do
  describe '.match?' do
    it 'returns text == "i"' do
      expect(Subsequent::Options::CycleChecklistItem.match?('blah1', 'blah2')).to eq(false)
    end

    it 'returns text == "i" (true)' do
      expect(Subsequent::Options::CycleChecklistItem.match?('blah1', 'i')).to eq(true)
    end
  end

  describe '.call' do
    it 'returns show_spinner do
        Subsequent::TrelloClient.update_checklist_item(checklist_item, pos:)
        Subsequent::Commands::FetchData.call(filter:, sort:)
      end' do
      Subsequent::Configuration.debug = true

      expect(Subsequent::Options::CycleChecklistItem.call(Subsequent::State.new(cards: [Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 1, short_url: 'blah4', checklists: [{card_id: "blah1", id: "blah2", name: "blah3", pos: 1, check_items: [{card_id: "blah1", id: "blah2", name: "blah3", pos: 1, state: "blah5"}]}])], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2')).to be_an_instance_of(Subsequent::State)
      expect(a_request(:put, %r{/1/cards/blah1/checkItem/blah2})).to have_been_made
      expect(a_request(:get, %r{/1/lists/default_list_id/cards})).to have_been_made
    end

    it 'raises Subsequent::Error' do
      Subsequent::Configuration.debug = true
      stub_request(:put, %r{/1/cards/blah1/checkItem/blah2}).to_return(status: 500)

      expect { Subsequent::Options::CycleChecklistItem.call(Subsequent::State.new(cards: [Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 1, short_url: 'blah4', checklists: [{card_id: "blah1", id: "blah2", name: "blah3", pos: 1, check_items: [{card_id: "blah1", id: "blah2", name: "blah3", pos: 1, state: "blah5"}]}])], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2') }.to raise_error(Subsequent::Error)
    end
  end
end
