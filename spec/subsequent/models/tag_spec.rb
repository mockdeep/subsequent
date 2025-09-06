# frozen_string_literal: true

RSpec.describe Subsequent::Models::Tag do
  describe "<=>" do
    it "returns -1 if the tag name is less than the other tag name" do
      tag1 = make_tag("@alpha")
      tag2 = make_tag("@beta")

      expect(tag1 <=> tag2).to eq(-1)
    end

    it "returns 1 if the tag name is greater than the other tag name" do
      tag1 = make_tag("@beta")
      tag2 = make_tag("@alpha")

      expect(tag1 <=> tag2).to eq(1)
    end

    it "returns 0 if the tag names are equal" do
      tag1 = make_tag("@tag")
      tag2 = make_tag("@tag")

      expect(tag1 <=> tag2).to eq(0)
    end
  end
end
