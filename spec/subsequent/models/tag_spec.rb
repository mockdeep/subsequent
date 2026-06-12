RSpec.describe Subsequent::Models::Tag do
  describe '#items' do
    it 'returns checklists.flat_map(&:unchecked_items)' do
      tag = Subsequent::Models::Tag.new('blah1', checklists: [Subsequent::Models::Checklist.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4')])

      expect(tag.items).to eq([])
    end
  end

  describe '#to_s' do
    it 'returns "#{name} (#{items.size})"' do
      tag = Subsequent::Models::Tag.new('blah1', checklists: [Subsequent::Models::Checklist.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4')])

      expect(tag.to_s).to eq('blah1 (0)')
    end
  end

  describe '#==' do
    it 'returns name == other when other.is_a?(String)' do
      tag = Subsequent::Models::Tag.new('blah1')

      expect(tag.==('blah3')).to eq(false)
    end

    it 'returns name == other (true) when other.is_a?(String)' do
      tag = Subsequent::Models::Tag.new('blah3')

      expect(tag.==('blah3')).to eq(true)
    end

    it 'returns other.name == name when !(other.is_a?(String))' do
      tag = Subsequent::Models::Tag.new('blah1')

      expect(tag.==(Subsequent::Models::Tag.new('blah1'))).to eq(true)
    end

    it 'returns other.name == name (false) when !(other.is_a?(String))' do
      tag = Subsequent::Models::Tag.new('')

      expect(tag.==(Subsequent::Models::Tag.new('blah1'))).to eq(false)
    end
  end

  describe '#<=>' do
    it 'returns name <=> other.name' do
      tag = Subsequent::Models::Tag.new('blah1')

      expect(tag.<=>(Subsequent::Models::Tag.new('blah1'))).to eq(0)
    end

    it 'returns name <=> other.name (-1)' do
      tag = Subsequent::Models::Tag.new('')

      expect(tag.<=>(Subsequent::Models::Tag.new('blah1'))).to eq(-1)
    end

    it 'returns name <=> other.name (1)' do
      tag = Subsequent::Models::Tag.new('blah1x')

      expect(tag.<=>(Subsequent::Models::Tag.new('blah1'))).to eq(1)
    end
  end

  describe '#checklists' do
    it 'returns @checklists' do
      tag = Subsequent::Models::Tag.new('blah1')

      expect(tag.checklists).to eq([])
    end
  end
end
