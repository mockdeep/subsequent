RSpec.describe Subsequent::Options::CycleMode do
  describe '.match?' do
    it 'returns text == "c"' do
      expect(Subsequent::Options::CycleMode.match?('blah1', 'blah2')).to eq(false)
    end

    it 'returns text == "c" (true)' do
      expect(Subsequent::Options::CycleMode.match?('blah1', 'c')).to eq(true)
    end
  end

  describe '.call' do
    it 'returns state.with(mode: Subsequent::Modes::Cycle)' do
      expect(Subsequent::Options::CycleMode.call(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2')).to be_an_instance_of(Subsequent::State)
    end
  end
end
