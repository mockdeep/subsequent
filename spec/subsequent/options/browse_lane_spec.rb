RSpec.describe Subsequent::Options::BrowseLane, :buttress_io do
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
      Subsequent::Configuration.debug = true

      expect(Subsequent::Options::BrowseLane.call(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2')).to be_an_instance_of(Subsequent::State)
      expect(a_request(:get, %r{/1/boards/default_board_id/lists})).to have_been_made
    end
  end
end
