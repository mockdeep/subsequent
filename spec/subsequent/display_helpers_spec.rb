# frozen_string_literal: true

RSpec.describe Subsequent::DisplayHelpers do
  include described_class

  describe "#linkify" do
    it "returns a string with links" do
      string = "http://example.com is a great website"

      expect(linkify(string))
        .to eq("(#{link("http://example.com")}) is a great website")
    end
  end
end
