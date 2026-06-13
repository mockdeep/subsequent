RSpec.describe Subsequent::Options::AddItemMode do
  describe '.match?' do
    it 'returns text == "n"' do
      expect(Subsequent::Options::AddItemMode.match?('blah1', 'blah2')).to eq(false)
    end

    it 'returns text == "n" (true)' do
      expect(Subsequent::Options::AddItemMode.match?('blah1', 'n')).to eq(true)
    end
  end

  describe '.call' do
    it 'returns state.with(mode: Subsequent::Modes::AddItem)' do
      expect(Subsequent::Options::AddItemMode.call(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2')).to be_an_instance_of(Subsequent::State)
    end
  end
end
