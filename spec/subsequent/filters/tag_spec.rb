RSpec.describe Subsequent::Filters::Tag do
  describe '#call' do
    it 'returns cards.each_with_object([]) do |card, result|
      matching =
        card.checklists.select do |checklist|
          checklist.unchecked_items? && checklist.tag_names.include?(tag_name)
        end
      next if matching.empty?

      result << card.with(checklists: matching)
    end' do
      tag = Subsequent::Filters::Tag.new('blah1')

      expect(tag.call([Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 'blah3', short_url: 'blah4', checklists: [])])).to eq([])
    end
  end

  describe '#==' do
    it 'returns other.respond_to?(:tag_name) && tag_name == other.tag_name' do
      tag = Subsequent::Filters::Tag.new('blah1')

      expect(tag.==(Subsequent::Filters::Tag.new('blah1'))).to eq(true)
    end
  end
end
