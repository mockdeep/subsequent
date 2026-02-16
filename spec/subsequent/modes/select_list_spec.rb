# frozen_string_literal: true

RSpec.describe Subsequent::Modes::SelectList do
  include Subsequent::DisplayHelpers

  describe ".commands" do
    it "returns a list of commands with lists" do
      lists = [make_list(name: "Todo")]
      state = make_state(lists:)

      expect(described_class.commands(state)).to include("(#{cyan("1")}) Todo")
    end

    it "shows page indicator when multiple pages exist" do
      lists = 10.times.map { |i| make_list(id: i.to_s, name: "L#{i}") }
      state = make_state(lists:)

      expect(described_class.commands(state)).to include("page 1/2")
    end

    it "hides paging hints when only one page" do
      lists = [make_list]
      state = make_state(lists:)

      expect(described_class.commands(state)).not_to include("page")
    end
  end

  describe ".handle_input" do
    it "returns state with Normal mode when input is q" do
      state = make_state
      mock_input("q")

      expect(described_class.handle_input(state))
        .to eq(state.with(mode: Subsequent::Modes::Normal))
    end

    it "returns state unchanged when input is something else" do
      state = make_state
      mock_input("z")

      expect(described_class.handle_input(state)).to eq(state)
    end
  end
end
