RSpec.describe Subsequent::Options::Refresh, :buttress_io do
  describe '.match?' do
    it 'returns text == "r"' do
      expect(Subsequent::Options::Refresh.match?('blah1', 'blah2')).to eq(false)
    end

    it 'returns text == "r" (true)' do
      expect(Subsequent::Options::Refresh.match?('blah1', 'r')).to eq(true)
    end
  end

  describe '.call' do
    it 'returns restore_selection(new_state, state)' do
      Subsequent::Configuration.debug = true

      expect(Subsequent::Options::Refresh.call(Subsequent::State.new(cards: [Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 'blah3', short_url: 'blah4', checklists: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", check_items: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", state: "blah5"}]}])], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2')).to be_an_instance_of(Subsequent::State)
      expect(a_request(:get, %r{/1/lists/default_list_id/cards})).to have_been_made
    end
  end
end
