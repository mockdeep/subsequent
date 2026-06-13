RSpec.describe Subsequent::Options::ToggleChecklistItem do
  describe '.match?' do
    it 'returns ("1"..state.checklist_items.size.to_s).include?(text)' do
      expect(Subsequent::Options::ToggleChecklistItem.match?(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2')).to eq(false)
    end
  end

  describe '.call' do
    it 'returns Subsequent::Commands::ToggleChecklistItem.call(state, text)' do
      skip 'Buttress cannot yet evaluate: recursion in #call'

      Subsequent::Options::ToggleChecklistItem.call('blah1', 'blah2')
    end
  end
end
