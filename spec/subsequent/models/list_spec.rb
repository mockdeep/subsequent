# frozen_string_literal: true

RSpec.describe Subsequent::Models::List do
  describe "#==" do
    it "returns true for same id" do
      list1 = make_list(id: "1")
      list2 = make_list(id: "1")

      expect(list1).to eq(list2)
    end

    it "returns false for different id" do
      list1 = make_list(id: "1")
      list2 = make_list(id: "2")

      expect(list1).not_to eq(list2)
    end
  end

  it "ignores unknown keys" do
    list = described_class.new(id: "1", name: "Test", closed: false)

    expect(list.name).to eq("Test")
  end
end
