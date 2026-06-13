RSpec.describe Subsequent::Options::CreateChecklistItem do
  describe '.match?' do
    it 'returns true' do
      expect(Subsequent::Options::CreateChecklistItem.match?).to eq(true)
    end
  end

  describe '.call' do
    it 'returns state.with(mode: Subsequent::Modes::AddChecklistItem)' do
      skip 'Buttress cannot yet evaluate: state => { checklist:, filter:, sort: }'

      Subsequent::Options::CreateChecklistItem.call('blah1', 'blah2')
    end
  end
end
