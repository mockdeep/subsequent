RSpec.describe Subsequent::Options::BrowseMode do
  describe '.match?' do
    it 'returns text == "b"' do
      expect(Subsequent::Options::BrowseMode.match?('blah1', 'blah2')).to eq(false)
    end

    it 'returns text == "b" (true)' do
      expect(Subsequent::Options::BrowseMode.match?('blah1', 'b')).to eq(true)
    end
  end

  describe '.call' do
    it 'returns state.with(mode: Subsequent::Modes::Browse)' do
      expect(Subsequent::Options::BrowseMode.call(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2')).to be_an_instance_of(Subsequent::State)
    end
  end
end
