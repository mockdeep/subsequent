RSpec.describe Subsequent::Options::PrevBrowsePage do
  describe '.match?' do
    it 'returns text == "<" when text != "<"' do
      expect(Subsequent::Options::PrevBrowsePage.match?('blah1', 'not <')).to eq(false)
    end

    it 'returns state.browse_page.positive? when text == "<"' do
      expect(Subsequent::Options::PrevBrowsePage.match?(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), '<')).to eq(false)
    end
  end

  describe '.call' do
    it 'returns state.with(browse_page: state.browse_page - 1)' do
      expect(Subsequent::Options::PrevBrowsePage.call(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2')).to be_an_instance_of(Subsequent::State)
    end
  end
end
