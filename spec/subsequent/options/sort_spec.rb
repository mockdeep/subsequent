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
      skip 'Buttress cannot yet evaluate: state => { cards:, filter: }'

      Subsequent::Options::Sort.call('blah1', 'blah2')
    end
  end
end
