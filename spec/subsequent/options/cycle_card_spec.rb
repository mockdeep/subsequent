RSpec.describe Subsequent::Options::CycleCard do
  describe '.match?' do
    it 'returns text == "c"' do
      expect(Subsequent::Options::CycleCard.match?('blah1', 'blah2')).to eq(false)
    end

    it 'returns text == "c" (true)' do
      expect(Subsequent::Options::CycleCard.match?('blah1', 'c')).to eq(true)
    end
  end

  describe '.call' do
    it 'returns show_spinner do
        Subsequent::TrelloClient.update_card(card, pos:)
        Subsequent::Commands::FetchData.call(filter:, sort:)
      end' do
      skip 'Buttress cannot yet evaluate: String#cards'

      Subsequent::Options::CycleCard.call('blah1', 'blah2')
    end
  end
end
