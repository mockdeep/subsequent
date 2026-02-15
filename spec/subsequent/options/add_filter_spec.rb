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
  end

  describe ".call" do
    it "returns state with a Tag filter" do
      checklist = api_checklist(name: "@tag1", check_items: [api_item])
      state = make_state(cards: [make_card(checklists: [checklist])])
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)

      expect(described_class.call(state, "1").filter)
        .to be_a(Subsequent::Filters::Tag)
    end
  end
end
