RSpec.describe Subsequent::Options::ArchiveCard do
  describe '.match?' do
    it 'returns text == "a"' do
      expect(Subsequent::Options::ArchiveCard.match?('blah1', 'blah2')).to eq(false)
    end

    it 'returns text == "a" (true)' do
      expect(Subsequent::Options::ArchiveCard.match?('blah1', 'a')).to eq(true)
    end
  end

  describe '.call' do
    it 'returns Subsequent::Commands::ArchiveCard.call(state)' do
      skip 'Buttress cannot yet evaluate: cannot bind arguments for #call'

      Subsequent::Options::ArchiveCard.call('blah1', 'blah2')
    end
  end
end
