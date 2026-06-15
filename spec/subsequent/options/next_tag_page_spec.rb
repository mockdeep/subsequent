RSpec.describe Subsequent::Options::NextTagPage do
  describe '.match?' do
    it 'returns text == ">" when text != ">"' do
      expect(Subsequent::Options::NextTagPage.match?('blah1', 'not >')).to eq(false)
    end

    it 'returns state.tag_page < state.tags.each_slice(9).count - 1 when text == ">"' do
      expect(Subsequent::Options::NextTagPage.match?(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), '>')).to eq(false)
    end
  end

  describe '.call' do
    it 'returns state.with(tag_page: state.tag_page + 1)' do
      expect(Subsequent::Options::NextTagPage.call(Subsequent::State.new(cards: [], sort: Subsequent::Sorts::First, filter: Subsequent::Filters::None), 'blah2')).to be_an_instance_of(Subsequent::State)
    end
  end
end
