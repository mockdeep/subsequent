RSpec.describe Subsequent::TextFormatting do
  include described_class

  describe "#linkify" do
    it "returns a string with links" do
      string = "http://example.com is a great website"

      expect(linkify(string))
        .to eq("(#{link("http://example.com")}) is a great website")
    end 
  end
end
