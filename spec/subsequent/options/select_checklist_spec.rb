RSpec.describe Subsequent::Options::SelectChecklist do
  describe '.match?' do
    it 'returns false when page_size.zero?' do
      expect(Subsequent::Options::SelectChecklist.match?(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2')).to eq(false)
    end

    it 'returns ("1"..page_size.to_s).to_a.include?(text) when !(page_size.zero?)' do
      skip 'Buttress cannot yet evaluate: String#browse_page'

      Subsequent::Options::SelectChecklist.match?('blah1', 'blah2')
    end
  end

  describe '.call' do
    it 'returns state.with(
        browsed_checklist: true,
        checklist:,
        checklist_items: checklist.unchecked_items.first(5),
        mode: Subsequent::Modes::Normal,
      )' do
      skip 'Buttress cannot yet evaluate: Integer(text)'

      Subsequent::Options::SelectChecklist.call('blah1', 'blah2')
    end
  end
end
