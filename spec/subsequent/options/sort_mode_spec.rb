RSpec.describe Subsequent::Options::SortMode do
  describe '.match?' do
    it 'returns text == "s"' do
      expect(Subsequent::Options::SortMode.match?('blah1', 'blah2')).to eq(false)
    end

    it 'returns text == "s" (true)' do
      expect(Subsequent::Options::SortMode.match?('blah1', 's')).to eq(true)
    end
  end

  describe '.call' do
    it 'returns state.with(mode: Subsequent::Modes::Sort)' do
      expect(Subsequent::Options::SortMode.call(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2')).to be_an_instance_of(Subsequent::State)
    end
  end
end
