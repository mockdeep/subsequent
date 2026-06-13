RSpec.describe Subsequent::Options::CycleChecklistItem do
  describe '.match?' do
    it 'returns text == "i"' do
      expect(Subsequent::Options::CycleChecklistItem.match?('blah1', 'blah2')).to eq(false)
    end

    it 'returns text == "i" (true)' do
      expect(Subsequent::Options::CycleChecklistItem.match?('blah1', 'i')).to eq(true)
    end
  end

  describe '.call' do
    it 'returns show_spinner do
        Subsequent::TrelloClient.update_checklist_item(checklist_item, pos:)
        Subsequent::Commands::FetchData.call(filter:, sort:)
      end' do
      skip 'Buttress cannot yet evaluate: String#checklist'

      Subsequent::Options::CycleChecklistItem.call('blah1', 'blah2')
    end
  end
end
