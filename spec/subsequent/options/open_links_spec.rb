RSpec.describe Subsequent::Options::OpenLinks do
  describe '.match?' do
    it 'returns text == "o"' do
      expect(Subsequent::Options::OpenLinks.match?('blah1', 'blah2')).to eq(false)
    end

    it 'returns text == "o" (true)' do
      expect(Subsequent::Options::OpenLinks.match?('blah1', 'o')).to eq(true)
    end
  end

  describe '.call' do
    it 'returns Subsequent::Commands::OpenLinks.call(state)' do
      skip 'Buttress cannot yet evaluate: cannot bind arguments for #call'

      Subsequent::Options::OpenLinks.call('blah1', 'blah2')
    end
  end
end
