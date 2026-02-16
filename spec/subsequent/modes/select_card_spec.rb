# frozen_string_literal: true

RSpec.describe Subsequent::Modes::SelectCard do
  include Subsequent::DisplayHelpers

  describe ".commands" do
    it "returns a list of commands with cards" do
      card = make_card(name: "My Card")
      state = make_state(cards: [card])

      expect(described_class.commands(state))
        .to include("(#{cyan("1")}) My Card")
    end

    it "shows page indicator when multiple pages exist" do
      cards = 10.times.map { |i| make_card(id: i, name: "C#{i}") }
      state = make_state(cards:)

      expect(described_class.commands(state)).to include("page 1/2")
    end

    it "hides paging hints when only one page" do
      state = make_state(cards: [make_card])

      expect(described_class.commands(state)).not_to include("page")
    end
  end

  describe ".handle_input" do
    it "returns to SelectList when input is q" do
      state = make_state
      mock_input("q")

      result = described_class.handle_input(state)

      expect(result.mode).to eq(Subsequent::Modes::SelectList)
    end

    it "returns state unchanged when input is something else" do
      state = make_state
      mock_input("z")

      expect(described_class.handle_input(state)).to eq(state)
    end
  end
end
