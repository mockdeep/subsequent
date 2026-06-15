RSpec.describe Subsequent::Options::RemoveFilters, :buttress_io do
  describe '.match?' do
    it 'returns text == "n"' do
      expect(Subsequent::Options::RemoveFilters.match?('blah1', 'blah2')).to eq(false)
    end

    it 'returns text == "n" (true)' do
      expect(Subsequent::Options::RemoveFilters.match?('blah1', 'n')).to eq(true)
    end
  end

  describe '.call' do
    it 'returns Subsequent::Commands::FetchData.call(
        filter:, sort: state.sort, list_id: state.browse_list_id,
      )' do
      expect(Subsequent::Options::RemoveFilters.call(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2')).to be_an_instance_of(Subsequent::State)
      expect(a_request(:get, %r{/1/lists/default_list_id/cards})).to have_been_made
    end

    it 'raises Subsequent::Error' do
      stub_request(:get, %r{/1/lists/default_list_id/cards}).to_return(status: 500)

      expect { Subsequent::Options::RemoveFilters.call(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2') }.to raise_error(Subsequent::Error)
    end
  end
end
