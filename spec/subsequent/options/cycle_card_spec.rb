RSpec.describe Subsequent::Options::CycleCard, :buttress_io do
  describe '.match?' do
    it 'returns text == "c"' do
      expect(Subsequent::Options::CycleCard.match?('blah1', 'blah2')).to eq(false)
    end

    it 'returns text == "c" (true)' do
      expect(Subsequent::Options::CycleCard.match?('blah1', 'c')).to eq(true)
    end
  end

  describe '.call' do
    it 'returns show_spinner do
        Subsequent::TrelloClient.update_card(card, pos:)
        Subsequent::Commands::FetchData.call(filter:, sort:)
      end' do
      Subsequent::Configuration.debug = true
      stub_request(:put, %r{/1/cards/blah1}).to_return(status: 200, body: "[{\"id\":\"blah1\",\"name\":\"blah2\",\"pos\":1,\"short_url\":\"blah4\",\"checklists\":[{\"card_id\":\"blah1\",\"id\":\"blah2\",\"name\":\"blah3\",\"pos\":1,\"check_items\":[{\"card_id\":\"blah1\",\"id\":\"blah2\",\"name\":\"blah3\",\"pos\":1,\"state\":\"blah5\"}]}]}]")
      stub_request(:get, %r{/1/lists/default_list_id/cards}).to_return(status: 200, body: "[{\"id\":\"blah1\",\"name\":\"blah2\",\"pos\":1,\"short_url\":\"blah4\",\"checklists\":[{\"card_id\":\"blah1\",\"id\":\"blah2\",\"name\":\"blah3\",\"pos\":1,\"check_items\":[{\"card_id\":\"blah1\",\"id\":\"blah2\",\"name\":\"blah3\",\"pos\":1,\"state\":\"blah5\"}]}]}]")

      expect(Subsequent::Options::CycleCard.call(Subsequent::State.new(cards: [Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 1, short_url: 'blah4', checklists: [{card_id: "blah1", id: "blah2", name: "blah3", pos: 1, check_items: [{card_id: "blah1", id: "blah2", name: "blah3", pos: 1, state: "blah5"}]}])], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2')).to eq(Subsequent::State.new(cards: [Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 1, short_url: 'blah4', checklists: [{card_id: "blah1", id: "blah2", name: "blah3", pos: 1, check_items: [{card_id: "blah1", id: "blah2", name: "blah3", pos: 1, state: "blah5"}]}])], filter: Subsequent::Filters::None, sort: Subsequent::Sorts::First, browse_list_id: nil))
      expect(a_request(:put, %r{/1/cards/blah1})).to have_been_made
      expect(a_request(:get, %r{/1/lists/default_list_id/cards})).to have_been_made
    end

    it 'raises Subsequent::Error' do
      Subsequent::Configuration.debug = true
      stub_request(:put, %r{/1/cards/blah1}).to_return(status: 500)

      expect { Subsequent::Options::CycleCard.call(Subsequent::State.new(cards: [Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 1, short_url: 'blah4', checklists: [{card_id: "blah1", id: "blah2", name: "blah3", pos: 1, check_items: [{card_id: "blah1", id: "blah2", name: "blah3", pos: 1, state: "blah5"}]}])], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2') }.to raise_error(Subsequent::Error)
    end
  end
end
