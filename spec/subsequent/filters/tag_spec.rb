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
      tag = Subsequent::Filters::Tag.new('<no tag>')

      expect(tag.call([Subsequent::Models::Card.new(id: 'blah1', name: 'blah2', pos: 'blah3', short_url: 'blah4', checklists: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", check_items: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", state: "blah5"}]}])])).to eq([Subsequent::Models::Card.new(checklists: [Subsequent::Models::Checklist.new(card_id: 'blah1', id: 'blah2', name: 'blah3', pos: 'blah4', check_items: [{card_id: "blah1", id: "blah2", name: "blah3", pos: "blah4", state: "blah5"}])], id: 'blah1', name: 'blah2', pos: 'blah3', short_url: 'blah4')])
    end
  end

  describe '#==' do
    it 'returns other.respond_to?(:tag_name) when !(other.respond_to?(:tag_name))' do
      tag = Subsequent::Filters::Tag.new('blah1')

      expect(tag.==('blah2')).to eq(false)
    end

    it 'returns tag_name == other.tag_name when other.respond_to?(:tag_name)' do
      tag = Subsequent::Filters::Tag.new('blah1')

      expect(tag.==(Subsequent::Filters::Tag.new('blah1'))).to eq(true)
    end

    it 'returns tag_name == other.tag_name (false) when other.respond_to?(:tag_name)' do
      tag = Subsequent::Filters::Tag.new('')

      expect(tag.==(Subsequent::Filters::Tag.new('blah1'))).to eq(false)
    end
  end
end
