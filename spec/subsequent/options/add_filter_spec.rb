RSpec.describe Subsequent::Options::AddFilter, :buttress_io do
  describe '.match?' do
    it 'returns false when page_size.zero?' do
      expect(Subsequent::Options::AddFilter.match?(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2')).to eq(false)
    end

    it 'returns ("1"..page_size.to_s).to_a.include?(text) when !(page_size.zero?)' do
      expect(Subsequent::Options::AddFilter.match?(Subsequent::State.new(cards: [Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 'blah3', short_url: 'blah4', checklists: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", check_items: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", state: "blah5"}]}])], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), '1')).to eq(true)
    end

    it 'returns ("1"..page_size.to_s).to_a.include?(text) (false) when !(page_size.zero?)' do
      expect(Subsequent::Options::AddFilter.match?(Subsequent::State.new(cards: [Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 'blah3', short_url: 'blah4', checklists: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", check_items: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", state: "blah5"}]}])], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), '')).to eq(false)
    end
  end

  describe '.call' do
    it 'returns Subsequent::Commands::FetchData.call(
        filter:, sort: state.sort, list_id: state.browse_list_id,
      )' do
      stub_request(:get, %r{/1/lists/default_list_id/cards}).to_return(status: 200, body: "[{\"id\":\"blah1\",\"name\":\"blah2\",\"pos\":\"blah3\",\"short_url\":\"blah4\",\"checklists\":[{\"card_id\":\"blah1\",\"id\":\"blah2\",\"name\":\"blah3\",\"pos\":\"blah4\",\"check_items\":[{\"card_id\":\"blah1\",\"id\":\"blah2\",\"name\":\"blah3\",\"pos\":\"blah4\",\"state\":\"blah5\"}]}]}]")

      expect(Subsequent::Options::AddFilter.call(Subsequent::State.new(cards: [Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 'blah3', short_url: 'blah4', checklists: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", check_items: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", state: "blah5"}]}])], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), '1')).to eq(Subsequent::State.new(cards: [Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 'blah3', short_url: 'blah4', checklists: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", check_items: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", state: "blah5"}]}])], filter: Subsequent::Filters::Tag.new('<no tag>'), sort: Subsequent::Sorts::First, browse_list_id: nil))
      expect(a_request(:get, %r{/1/lists/default_list_id/cards})).to have_been_made
    end

    it 'raises Subsequent::Error' do
      stub_request(:get, %r{/1/lists/default_list_id/cards}).to_return(status: 500)

      expect { Subsequent::Options::AddFilter.call(Subsequent::State.new(cards: [Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 'blah3', short_url: 'blah4', checklists: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", check_items: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", state: "blah5"}]}])], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), '1') }.to raise_error(Subsequent::Error)
    end
  end
end
