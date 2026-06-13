RSpec.describe Subsequent::Options::BrowseChecklist do
  describe '.match?' do
    it 'returns text == "k"' do
      expect(Subsequent::Options::BrowseChecklist.match?('blah1', 'blah2')).to eq(false)
    end

    it 'returns text == "k" (true)' do
      expect(Subsequent::Options::BrowseChecklist.match?('blah1', 'k')).to eq(true)
    end
  end

  describe '.call' do
    it 'returns state.with(mode: Subsequent::Modes::SelectChecklist, browse_page: 0)' do
      expect(Subsequent::Options::BrowseChecklist.call(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2')).to be_an_instance_of(Subsequent::State)
    end
  end
end
