RSpec.describe Subsequent::Options::Cancel do
  describe '.match?' do
    it 'returns ["", "q", "\u0004", "\u0003"].include?(text)' do
      expect(Subsequent::Options::Cancel.match?('blah1', '')).to eq(true)
    end

    it 'returns ["", "q", "\u0004", "\u0003"].include?(text) (false)' do
      expect(Subsequent::Options::Cancel.match?('blah1', 'x')).to eq(false)
    end
  end

  describe '.call' do
    it 'returns state.with(mode: Subsequent::Modes::Normal)' do
      expect(Subsequent::Options::Cancel.call(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2')).to be_an_instance_of(Subsequent::State)
    end
  end
end
