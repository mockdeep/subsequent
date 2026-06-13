RSpec.describe Subsequent::Options::CreateChecklist do
  describe '.match?' do
    it 'returns true' do
      expect(Subsequent::Options::CreateChecklist.match?).to eq(true)
    end
  end

  describe '.call' do
    it 'returns Subsequent::Commands::CreateChecklist.call(state, text)' do
      skip 'Buttress cannot yet evaluate: recursion in #call'

      Subsequent::Options::CreateChecklist.call('blah1', 'blah2')
    end
  end
end
