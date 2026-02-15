# frozen_string_literal: true

RSpec.describe Subsequent::Options::NextTagPage do
  describe ".match?" do
    it "returns true when text is > and more pages exist" do
      state = state_with_tags(10)

      expect(described_class.match?(state, ">")).to be(true)
    end

    it "returns false when on the last page" do
      state = state_with_tags(9)

      expect(described_class.match?(state, ">")).to be(false)
    end

    it "returns false when text is not >" do
      state = state_with_tags(10)

      expect(described_class.match?(state, "x")).to be(false)
    end
  end

  describe ".call" do
    it "increments tag_page" do
      state = state_with_tags(10)

      expect(described_class.call(state, ">").tag_page).to eq(1)
    end
  end

  def state_with_tags(count)
    cards =
      count.times.map do |i|
        checklist = api_checklist(name: "@tag#{i}", check_items: [api_item])
        make_card(id: i, checklists: [checklist])
      end
    make_state(cards:)
  end
end
