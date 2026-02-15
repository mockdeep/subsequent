# frozen_string_literal: true

RSpec.describe Subsequent::Options::AddFilter do
  describe ".match?" do
    it "returns true when text is a number in tag range" do
      checklist = api_checklist(name: "@tag1", check_items: [api_item])
      state = make_state(cards: [make_card(checklists: [checklist])])

      expect(described_class.match?(state, "1")).to be(true)
    end

    it "returns false when text is out of tag range" do
      expect(described_class.match?(make_state, "5")).to be(false)
    end

    it "returns false when text is not a number" do
      expect(described_class.match?(make_state, "x")).to be(false)
    end

    it "matches valid index on the current page" do
      state = state_with_tags(10, tag_page: 1)

      expect(described_class.match?(state, "1")).to be(true)
    end

    it "rejects index beyond current page size" do
      state = state_with_tags(10, tag_page: 1)

      expect(described_class.match?(state, "2")).to be(false)
    end
  end

  describe ".call" do
    it "returns state with a Tag filter" do
      checklist = api_checklist(name: "@tag1", check_items: [api_item])
      state = make_state(cards: [make_card(checklists: [checklist])])
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)

      expect(described_class.call(state, "1").filter)
        .to be_a(Subsequent::Filters::Tag)
    end

    it "offsets index by page when selecting a tag" do
      state = state_with_tags(10, tag_page: 1)
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)

      result = described_class.call(state, "1")

      expect(result.filter).to eq(Subsequent::Filters::Tag.new("@tag9"))
    end
  end

  def state_with_tags(count, tag_page: 0)
    cards =
      count.times.map do |i|
        checklist = api_checklist(name: "@tag#{i}", check_items: [api_item])
        make_card(id: i, checklists: [checklist])
      end
    make_state(cards:, tag_page:)
  end
end
