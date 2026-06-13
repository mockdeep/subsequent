RSpec.describe Subsequent::Options::AddFilter do
  describe '.match?' do
    it 'returns false when page_size.zero?' do
      expect(Subsequent::Options::AddFilter.match?(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2')).to eq(false)
    end

    it 'returns ("1"..page_size.to_s).to_a.include?(text) when !(page_size.zero?)' do
      skip 'Buttress cannot yet evaluate: String#tag_page'

      Subsequent::Options::AddFilter.match?('blah1', 'blah2')
    end
  end

  describe '.call' do
    it 'returns Subsequent::Commands::FetchData.call(
        filter:, sort: state.sort, list_id: state.browse_list_id,
      )' do
      skip 'Buttress cannot yet evaluate: Integer(text)'

      Subsequent::Options::AddFilter.call('blah1', 'blah2')
    end
  end
end
