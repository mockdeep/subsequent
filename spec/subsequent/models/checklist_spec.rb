RSpec.describe Subsequent::Models::Checklist do
  describe '#<=>' do
    it 'returns pos <=> other.pos' do
      checklist = Subsequent::Models::Checklist.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4')

      expect(checklist.<=>(Subsequent::Models::Checklist.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4'))).to eq(0)
    end

    it 'returns pos <=> other.pos (-1)' do
      checklist = Subsequent::Models::Checklist.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: '')

      expect(checklist.<=>(Subsequent::Models::Checklist.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4'))).to eq(-1)
    end

    it 'returns pos <=> other.pos (1)' do
      checklist = Subsequent::Models::Checklist.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4x')

      expect(checklist.<=>(Subsequent::Models::Checklist.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4'))).to eq(1)
    end
  end

  describe '#unchecked_items?' do
    it 'returns unchecked_items.any?' do
      checklist = Subsequent::Models::Checklist.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4')

      expect(checklist.unchecked_items?).to eq(false)
    end
  end

  describe '#unchecked_items' do
    it 'returns items.reject(&:checked?)' do
      checklist = Subsequent::Models::Checklist.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4')

      expect(checklist.unchecked_items).to eq([])
    end
  end

  describe '#eql?' do
    it 'returns id == other.id' do
      checklist = Subsequent::Models::Checklist.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4')

      expect(checklist.eql?(Subsequent::Models::Checklist.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4'))).to eq(true)
    end

    it 'returns id == other.id (false)' do
      checklist = Subsequent::Models::Checklist.new(card_id: 'blah1', id: '', name: 'blah3', pos: 'blah4')

      expect(checklist.eql?(Subsequent::Models::Checklist.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4'))).to eq(false)
    end
  end

  describe '#hash' do
    it 'returns id.hash' do
      checklist = Subsequent::Models::Checklist.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4')

      expect(checklist.hash).to eq(checklist.id.hash)
    end
  end

  describe '#tag_names' do
    it 'returns names when names is empty' do
      checklist = Subsequent::Models::Checklist.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4')

      expect(checklist.tag_names).to eq(["<no tag>"])
    end

    it 'returns names when names is not empty' do
      checklist = Subsequent::Models::Checklist.new(card_id: 'blah1', id: 'blah2', name: '@', pos: 'blah4')

      expect(checklist.tag_names).to eq(["@"])
    end
  end

  describe '#items' do
    it 'returns @items' do
      checklist = Subsequent::Models::Checklist.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4')

      expect(checklist.items).to eq([])
    end
  end

  describe '.from_data' do
    it 'returns checklists_data
        .map { |checklist_data| new(card_id:, **checklist_data) }
        .sort' do
      expect(Subsequent::Models::Checklist.from_data([{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", check_items: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", state: "blah5"}]}], card_id: 'blah8')).to eq([Subsequent::Models::Checklist.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4', check_items: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", state: "blah5"}])])
    end
  end
end
