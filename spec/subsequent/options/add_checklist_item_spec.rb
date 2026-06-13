RSpec.describe Subsequent::Options::AddChecklistItem do
  describe '.match?' do
    it 'returns text == "i" when text != "i"' do
      expect(Subsequent::Options::AddChecklistItem.match?('blah1', 'not i')).to eq(false)
    end

    it 'returns state.checklist.present? when text == "i"' do
      expect(Subsequent::Options::AddChecklistItem.match?(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'i')).to eq(false)
    end
  end

  describe '.call' do
    it 'returns state.with(mode: Subsequent::Modes::AddChecklistItem)' do
      expect(Subsequent::Options::AddChecklistItem.call(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2')).to be_an_instance_of(Subsequent::State)
    end
  end
end
