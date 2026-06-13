RSpec.describe Subsequent::Options::FilterMode do
  describe '.match?' do
    it 'returns text == "f"' do
      expect(Subsequent::Options::FilterMode.match?('blah1', 'blah2')).to eq(false)
    end

    it 'returns text == "f" (true)' do
      expect(Subsequent::Options::FilterMode.match?('blah1', 'f')).to eq(true)
    end
  end

  describe '.call' do
    it 'returns state.with(mode: Subsequent::Modes::Filter, tag_page: 0)' do
      expect(Subsequent::Options::FilterMode.call(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2')).to be_an_instance_of(Subsequent::State)
    end
  end
end
