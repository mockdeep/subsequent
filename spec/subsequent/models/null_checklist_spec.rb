RSpec.describe Subsequent::Models::NullChecklist do
  describe '#name' do
    it 'returns "<no checklist>"' do
      null_checklist = Subsequent::Models::NullChecklist.new

      expect(null_checklist.name).to eq('<no checklist>')
    end
  end

  describe '#unchecked_items' do
    it 'returns []' do
      null_checklist = Subsequent::Models::NullChecklist.new

      expect(null_checklist.unchecked_items).to eq([])
    end
  end

  describe '#present?' do
    it 'returns false' do
      null_checklist = Subsequent::Models::NullChecklist.new

      expect(null_checklist.present?).to eq(false)
    end
  end

  describe '#==' do
    it 'returns other.is_a?(self.class)' do
      null_checklist = Subsequent::Models::NullChecklist.new

      expect(null_checklist.==(Subsequent::Models::NullChecklist.new)).to eq(true)
    end

    it 'returns other.is_a?(self.class) (false)' do
      null_checklist = Subsequent::Models::NullChecklist.new

      expect(null_checklist.==('blah1')).to eq(false)
    end
  end
end
