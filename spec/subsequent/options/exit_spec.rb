RSpec.describe Subsequent::Options::Exit do
  describe '.match?' do
    it 'returns ["q", "\u0004", "\u0003"].include?(text)' do
      expect(Subsequent::Options::Exit.match?('blah1', 'q')).to eq(true)
    end

    it 'returns ["q", "\u0004", "\u0003"].include?(text) (false)' do
      expect(Subsequent::Options::Exit.match?('blah1', '')).to eq(false)
    end
  end

  describe '.call' do
    it 'returns throw(:quit)' do
      skip 'Buttress cannot yet evaluate: terminal_title("")'

      Subsequent::Options::Exit.call('blah1', 'blah2')
    end
  end
end
