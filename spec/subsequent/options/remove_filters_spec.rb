# frozen_string_literal: true

RSpec.describe Subsequent::Options::RemoveFilters do
  describe ".match?" do
    it "returns true when text is n" do
      expect(described_class.match?(make_state, "n")).to be(true)
    end

    it "returns false when text is not n" do
      expect(described_class.match?(make_state, "x")).to be(false)
    end
  end

  describe ".call" do
    it "returns state with None filter" do
      state = make_state(filter: Subsequent::Filters::Tag.new(make_tag))
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)

      expect(described_class.call(state, "n").filter)
        .to eq(Subsequent::Filters::None)
    end

    it "fetches cards from the browsed lane" do
      state = make_state(browse_list_id: "lane-1")
      stub_request(:get, %r{lists/lane-1}).to_return(body: [api_card].to_json)

      expect(described_class.call(state, "n").browse_list_id).to eq("lane-1")
    end
  end
end
