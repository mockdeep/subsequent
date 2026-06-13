RSpec.describe Subsequent::Sorts::First do
  describe '.to_s' do
    it 'returns "first"' do
      expect(Subsequent::Sorts::First.to_s).to eq('first')
    end
  end

  describe '.call' do
    it 'returns cards.first' do
      expect(Subsequent::Sorts::First.call([])).to eq(nil)
    end
  end
end
