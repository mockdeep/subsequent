RSpec.describe Subsequent::Options::CreateCard do
  describe '.match?' do
    it 'returns true' do
      expect(Subsequent::Options::CreateCard.match?).to eq(true)
    end
  end

  describe '.call' do
    it 'returns state.with(mode: Subsequent::Modes::AddChecklist)' do
      skip 'Buttress cannot yet evaluate: String#filter'

      Subsequent::Options::CreateCard.call('blah1', 'blah2')
    end
  end
end
