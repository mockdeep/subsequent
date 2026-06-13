RSpec.describe Subsequent::Options::NextBrowsePage do
  describe '.match?' do
    it 'returns text == ">" when text != ">"' do
      expect(Subsequent::Options::NextBrowsePage.match?('blah1', 'not >')).to eq(false)
    end

    it 'returns state.browse_page < browse_items(state).each_slice(9).count - 1 when text == ">"' do
      skip 'Buttress cannot yet evaluate: case state.mode.name
      when "Subsequent::Modes::SelectList" then state.lists
      when "Subsequent::Modes::SelectCard" then state.cards
      when "Subsequent::Modes::SelectChecklist"
        state.browse_checklists
      else []
      end'

      Subsequent::Options::NextBrowsePage.match?('blah1', '>')
    end
  end

  describe '.call' do
    it 'returns state.with(browse_page: state.browse_page + 1)' do
      expect(Subsequent::Options::NextBrowsePage.call(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2')).to be_an_instance_of(Subsequent::State)
    end
  end
end
