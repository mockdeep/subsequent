RSpec.describe Subsequent::Options::SelectList do
  describe '.match?' do
    it 'returns false when page_size.zero?' do
      expect(Subsequent::Options::SelectList.match?(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2')).to eq(false)
    end

    it 'returns ("1"..page_size.to_s).to_a.include?(text) when !(page_size.zero?)' do
      skip 'Buttress cannot yet evaluate: String#browse_page'

      Subsequent::Options::SelectList.match?('blah1', 'blah2')
    end
  end

  describe '.call' do
    it 'returns show_spinner { fetch_and_transition(state, list) }' do
      skip 'Buttress cannot yet evaluate: Integer(text)'

      Subsequent::Options::SelectList.call('blah1', 'blah2')
    end
  end
end
