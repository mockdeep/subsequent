RSpec.describe Subsequent::Options::AddChecklist do
  describe '.match?' do
    it 'returns text == "l"' do
      expect(Subsequent::Options::AddChecklist.match?('blah1', 'blah2')).to eq(false)
    end

    it 'returns text == "l" (true)' do
      expect(Subsequent::Options::AddChecklist.match?('blah1', 'l')).to eq(true)
    end
  end

  describe '.call' do
    it 'returns state.with(mode: Subsequent::Modes::AddChecklist)' do
      expect(Subsequent::Options::AddChecklist.call(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2')).to be_an_instance_of(Subsequent::State)
    end
  end
end
