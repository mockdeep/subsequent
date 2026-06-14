RSpec.describe Subsequent::Options::Sort do
  describe '.match?' do
    it 'returns ["f", "l", "m"].include?(text)' do
      expect(Subsequent::Options::Sort.match?('blah1', 'f')).to eq(true)
    end

    it 'returns ["f", "l", "m"].include?(text) (false)' do
      expect(Subsequent::Options::Sort.match?('blah1', '')).to eq(false)
    end
  end

  describe '.call' do
    it 'returns Subsequent::State.new(cards:, filter:, sort:)' do
      expect(Subsequent::Options::Sort.call(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None, lists: [Subsequent::Models::List.new(id: 'blah1', name: 'blah2')]), 'f')).to be_an_instance_of(Subsequent::State)
    end
  end
end
