RSpec.describe Subsequent::Options::RemoveFilters do
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
      skip 'Buttress cannot yet evaluate: String#sort'

      Subsequent::Options::RemoveFilters.call('blah1', 'blah2')
    end
  end
end
