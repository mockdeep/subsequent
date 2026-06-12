RSpec.describe Subsequent::State do
  describe '#tags' do
    it 'returns tagged_checklists
      .map { |name, checklists| Subsequent::Models::Tag.new(name, checklists:) }
      .sort' do
      state = Subsequent::State.new(cards: [Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 'blah3', short_url: 'blah4', checklists: [])], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None)

      expect(state.tags).to eq([])
    end
  end

  describe '#title' do
    it 'returns "#{card.name} - #{checklist.name} (#{link(card.short_url)})"' do
      state = Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None)

      expect(state.title).to eq('<No card> - <no checklist> (]8;;\link]8;;\)')
    end
  end

  describe '#checklist_string' do
    it 'returns checklist_items
        .map.with_index { |item, index| "#{index + 1}. #{item}" }.join("\n") when checklist_items.any?' do
      state = Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None, checklist_items: ["item1"])

      expect(state.checklist_string).to eq('1. item1')
    end

    it 'returns "No unchecked items, finish the card!" when !(checklist_items.any?)' do
      state = Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None)

      expect(state.checklist_string).to eq('No unchecked items, finish the card!')
    end
  end

  describe '#list_string' do
    it 'returns paginated_string(lists, browse_page)' do
      state = Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None, lists: [Subsequent::Models::List.new(id: 'blah1', name: 'blah2')])

      expect(state.list_string).to eq('([36m1[0m) blah2')
    end
  end

  describe '#browse_cards_string' do
    it 'returns paginated_string(cards, browse_page)' do
      state = Subsequent::State.new(cards: [Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 'blah3', short_url: 'blah4', checklists: [])], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None)

      expect(state.browse_cards_string).to eq('([36m1[0m) blah2')
    end
  end

  describe '#browse_checklists' do
    it 'returns card.checklists.select(&:unchecked_items?)' do
      state = Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None)

      expect(state.browse_checklists).to eq([])
    end
  end

  describe '#browse_checklists_string' do
    it 'returns paginated_string(browse_checklists, browse_page)' do
      state = Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None)

      expect(state.browse_checklists_string).to eq('')
    end
  end

  describe '#tag_string' do
    it 'returns page_tags
      .map.with_index { |tag, index| "(#{cyan(index + 1)}) #{tag}" }
      .join("\n")' do
      state = Subsequent::State.new(cards: [Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 'blah3', short_url: 'blah4', checklists: [])], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None)

      expect(state.tag_string).to eq('')
    end
  end
end
