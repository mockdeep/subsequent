RSpec.describe Subsequent::Options::Refresh do
  describe '.match?' do
    it 'returns text == "r"' do
      expect(Subsequent::Options::Refresh.match?('blah1', 'blah2')).to eq(false)
    end

    it 'returns text == "r" (true)' do
      expect(Subsequent::Options::Refresh.match?('blah1', 'r')).to eq(true)
    end
  end

  describe '.call' do
    it 'returns restore_selection(new_state, state)' do
      skip 'Buttress cannot yet evaluate: state => { filter:, sort:, browse_list_id:, lists: }'

      Subsequent::Options::Refresh.call('blah1', 'blah2')
    end
  end
end
