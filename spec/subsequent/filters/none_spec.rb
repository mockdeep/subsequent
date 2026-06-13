RSpec.describe Subsequent::Filters::None do
  describe '.call' do
    it 'returns cards' do
      expect(Subsequent::Filters::None.call('blah1')).to eq('blah1')
    end
  end
end
