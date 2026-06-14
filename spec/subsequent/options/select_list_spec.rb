RSpec.describe Subsequent::Options::SelectList do
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
      skip 'Buttress cannot yet evaluate: Integer(text)'

      Subsequent::Options::SelectList.call('blah1', 'blah2')
    end
  end
end
