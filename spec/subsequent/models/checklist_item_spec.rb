RSpec.describe Subsequent::Models::ChecklistItem do
  describe '#<=>' do
    it 'returns pos <=> other.pos' do
      checklist_item = Subsequent::Models::ChecklistItem.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4', state: 'blah5')

      expect(checklist_item.<=>(Subsequent::Models::ChecklistItem.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4', state: 'blah5'))).to eq(0)
    end

    it 'returns pos <=> other.pos (-1)' do
      checklist_item = Subsequent::Models::ChecklistItem.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: '', state: 'blah5')

      expect(checklist_item.<=>(Subsequent::Models::ChecklistItem.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4', state: 'blah5'))).to eq(-1)
    end

    it 'returns pos <=> other.pos (1)' do
      checklist_item = Subsequent::Models::ChecklistItem.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4x', state: 'blah5')

      expect(checklist_item.<=>(Subsequent::Models::ChecklistItem.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4', state: 'blah5'))).to eq(1)
    end
  end

  describe '#checked?' do
    it 'returns state == "complete"' do
      checklist_item = Subsequent::Models::ChecklistItem.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4', state: 'blah5')

      expect(checklist_item.checked?).to eq(false)
    end

    it 'returns state == "complete" (true)' do
      checklist_item = Subsequent::Models::ChecklistItem.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4', state: 'complete')

      expect(checklist_item.checked?).to eq(true)
    end
  end

  describe '#loading?' do
    it 'returns state == "loading"' do
      checklist_item = Subsequent::Models::ChecklistItem.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4', state: 'blah5')

      expect(checklist_item.loading?).to eq(false)
    end

    it 'returns state == "loading" (true)' do
      checklist_item = Subsequent::Models::ChecklistItem.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4', state: 'loading')

      expect(checklist_item.loading?).to eq(true)
    end
  end

  describe '#icon' do
    it 'returns loading_spinner.next when loading? is true' do
      checklist_item = Subsequent::Models::ChecklistItem.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4', state: 'loading')

      expect(checklist_item.icon).to eq('○')
    end

    it 'returns "✔" when loading? is false and checked? is true' do
      checklist_item = Subsequent::Models::ChecklistItem.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4', state: 'complete')

      expect(checklist_item.icon).to eq('✔')
    end

    it 'returns "☐" when loading? is false and checked? is false' do
      checklist_item = Subsequent::Models::ChecklistItem.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4', state: 'blah5')

      expect(checklist_item.icon).to eq('☐')
    end
  end

  describe '#links' do
    it 'returns name.scan(%r{https?://\S+})' do
      checklist_item = Subsequent::Models::ChecklistItem.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4', state: 'blah5')

      expect(checklist_item.links).to eq([])
    end
  end

  describe '#formatted_name' do
    it 'returns yellow(linked_name) when loading? is true' do
      checklist_item = Subsequent::Models::ChecklistItem.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4', state: 'loading')

      expect(checklist_item.formatted_name).to eq('[33mblah3[0m')
    end

    it 'returns gray(linked_name) when loading? is false and checked? is true' do
      checklist_item = Subsequent::Models::ChecklistItem.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4', state: 'complete')

      expect(checklist_item.formatted_name).to eq('[94mblah3[0m')
    end

    it 'returns green(linked_name) when loading? is false and checked? is false' do
      checklist_item = Subsequent::Models::ChecklistItem.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4', state: 'blah5')

      expect(checklist_item.formatted_name).to eq('[32mblah3[0m')
    end
  end

  describe '#to_s' do
    it 'returns "#{icon} #{formatted_name}"' do
      checklist_item = Subsequent::Models::ChecklistItem.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4', state: 'blah5')

      expect(checklist_item.to_s).to eq('☐ [32mblah3[0m')
    end
  end
end
