# frozen_string_literal: true

RSpec.describe Subsequent::Options::BrowseMode do
  describe ".match?" do
    it "returns true when text is b" do
      expect(described_class.match?(make_state, "b")).to be(true)
    end

    it "returns false when text is not b" do
      expect(described_class.match?(make_state, "x")).to be(false)
    end
  end

  describe ".call" do
    it "enters SelectList mode" do
      stub_request(:get, /lists/).to_return(body: [api_list].to_json)

      result = described_class.call(make_state, "b")

      expect(result.mode).to eq(Subsequent::Modes::SelectList)
    end

    it "populates lists" do
      stub_request(:get, /lists/).to_return(body: [api_list].to_json)

      result = described_class.call(make_state, "b")

      expect(result.lists.size).to eq(1)
    end
  end
end
