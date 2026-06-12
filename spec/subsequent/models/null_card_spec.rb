RSpec.describe Subsequent::Models::NullCard do
  describe '#checklists' do
    it 'returns []' do
      null_card = Subsequent::Models::NullCard.new

      expect(null_card.checklists).to eq([])
    end
  end

  describe '#name' do
    it 'returns "<No card>"' do
      null_card = Subsequent::Models::NullCard.new

      expect(null_card.name).to eq('<No card>')
    end
  end

  describe '#short_url' do
    it 'returns nil' do
      null_card = Subsequent::Models::NullCard.new

      expect(null_card.short_url).to eq(nil)
    end
  end
end
