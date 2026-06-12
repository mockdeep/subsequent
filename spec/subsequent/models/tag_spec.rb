RSpec.describe Subsequent::Models::Tag do
  describe '#items' do
    it 'returns checklists.flat_map(&:unchecked_items)' do
      tag = Subsequent::Models::Tag.new('blah1')

      expect(tag.items).to eq([])
    end
  end

  describe '#to_s' do
    it 'returns "#{name} (#{items.size})"' do
      tag = Subsequent::Models::Tag.new('blah1')

      expect(tag.to_s).to eq('blah1 (0)')
    end
  end

  describe '#==' do
    it 'returns name == other when other.is_a?(String)' do
      tag = Subsequent::Models::Tag.new('blah1')

      expect(tag.==('blah1')).to eq(true)
    end

    it 'returns other.name == name when !(other.is_a?(String))' do
      tag = Subsequent::Models::Tag.new('blah1')

      expect(tag.==(Subsequent::Models::Tag.new('blah1'))).to eq(true)
    end
  end

  describe '#<=>' do
    it 'returns name <=> other.name' do
      tag = Subsequent::Models::Tag.new('blah1')

      expect(tag.<=>(Subsequent::Models::Tag.new('blah1'))).to eq(0)
    end
  end
end
