# frozen_string_literal: true

RSpec.describe Subsequent::Options::SelectList do
  describe ".match?" do
    it "returns true when text is a number in list range" do
      state = make_state(lists: [make_list])

      expect(described_class.match?(state, "1")).to be(true)
    end

    it "returns false when text is out of list range" do
      state = make_state(lists: [make_list])

      expect(described_class.match?(state, "5")).to be(false)
    end

    it "returns false when no lists" do
      expect(described_class.match?(make_state, "1")).to be(false)
    end

    it "returns false when text is not a number" do
      state = make_state(lists: [make_list])

      expect(described_class.match?(state, "x")).to be(false)
    end

    it "matches valid index on the current page" do
      lists = 10.times.map { |i| make_list(id: i.to_s, name: "L#{i}") }
      state = make_state(lists:, browse_page: 1)

      expect(described_class.match?(state, "1")).to be(true)
    end

    it "rejects index beyond current page size" do
      lists = 10.times.map { |i| make_list(id: i.to_s, name: "L#{i}") }
      state = make_state(lists:, browse_page: 1)

      expect(described_class.match?(state, "2")).to be(false)
    end
  end

  describe ".call" do
    it "transitions to SelectCard mode" do
      state = make_state(lists: [make_list(id: "list-1")])
      stub_request(:get, %r{lists/list-1/cards})
        .to_return(body: [api_card].to_json)

      result = described_class.call(state, "1")

      expect(result.mode).to eq(Subsequent::Modes::SelectCard)
    end

    it "sets browse_list_id to the selected list" do
      state = make_state(lists: [make_list(id: "list-1")])
      stub_request(:get, %r{lists/list-1/cards})
        .to_return(body: [api_card].to_json)

      result = described_class.call(state, "1")

      expect(result.browse_list_id).to eq("list-1")
    end

    it "fetches cards for the selected list" do
      state = make_state(lists: [make_list(id: "list-1")])
      stub_request(:get, %r{lists/list-1/cards})
        .to_return(body: [api_card].to_json)

      result = described_class.call(state, "1")

      expect(result.cards.size).to eq(1)
    end

    it "offsets index by page" do
      lists = 10.times.map { |i| make_list(id: "l#{i}", name: "L#{i}") }
      state = make_state(lists:, browse_page: 1)
      stub_request(:get, %r{lists/l9/cards}).to_return(body: [api_card].to_json)

      expect(described_class.call(state, "1").browse_list_id).to eq("l9")
    end
  end
end
