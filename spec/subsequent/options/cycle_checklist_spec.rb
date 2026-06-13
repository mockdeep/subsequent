RSpec.describe Subsequent::Options::CycleChecklist do
  describe '.match?' do
    it 'returns text == "l"' do
      expect(Subsequent::Options::CycleChecklist.match?('blah1', 'blah2')).to eq(false)
    end

    it 'returns text == "l" (true)' do
      expect(Subsequent::Options::CycleChecklist.match?('blah1', 'l')).to eq(true)
    end
  end

  describe '.call' do
    it 'returns show_spinner do
        Subsequent::TrelloClient.update_checklist(checklist, pos:)
        Subsequent::Commands::FetchData.call(filter:, sort:)
      end' do
      skip 'Buttress cannot yet evaluate: String#card'

      Subsequent::Options::CycleChecklist.call('blah1', 'blah2')
    end
  end
end
