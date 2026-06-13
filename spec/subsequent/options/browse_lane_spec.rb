RSpec.describe Subsequent::Options::BrowseLane do
  describe '.match?' do
    it 'returns text == "l"' do
      expect(Subsequent::Options::BrowseLane.match?('blah1', 'blah2')).to eq(false)
    end

    it 'returns text == "l" (true)' do
      expect(Subsequent::Options::BrowseLane.match?('blah1', 'l')).to eq(true)
    end
  end

  describe '.call' do
    it 'returns show_spinner { Subsequent::Commands::FetchLists.call(state) }' do
      skip 'Buttress cannot yet evaluate: show_spinner { Subsequent::Commands::FetchLists.call(state) }'

      Subsequent::Options::BrowseLane.call('blah1', 'blah2')
    end
  end
end
