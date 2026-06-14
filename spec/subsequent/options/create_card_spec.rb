RSpec.describe Subsequent::Options::CreateCard, :buttress_io do
  describe '.match?' do
    it 'returns true' do
      expect(Subsequent::Options::CreateCard.match?).to eq(true)
    end
  end

  describe '.call' do
    it 'returns state.with(mode: Subsequent::Modes::AddChecklist)' do
      expect(Subsequent::Options::CreateCard.call(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2')).to be_an_instance_of(Subsequent::State)
      expect(a_request(:post, %r{/1/cards})).to have_been_made
      expect(a_request(:get, %r{/1/lists/default_list_id/cards})).to have_been_made
    end
  end
end
