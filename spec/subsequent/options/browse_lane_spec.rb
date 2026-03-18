# frozen_string_literal: true

RSpec.describe Subsequent::Options::BrowseLane do
  describe ".match?" do
    it "returns true when text is l" do
      expect(described_class.match?(make_state, "l")).to be(true)
    end

    it "returns false when text is not l" do
      expect(described_class.match?(make_state, "x")).to be(false)
    end
  end

  describe ".call" do
    it "enters SelectList mode" do
      stub_request(:get, /lists/).to_return(body: [api_list].to_json)

      result = described_class.call(make_state, "l")

      expect(result.mode).to eq(Subsequent::Modes::SelectList)
    end

    it "populates lists" do
      stub_request(:get, /lists/).to_return(body: [api_list].to_json)

      result = described_class.call(make_state, "l")

      expect(result.lists.size).to eq(1)
    end
  end
end
