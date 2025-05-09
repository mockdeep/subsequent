# frozen_string_literal: true

RSpec.describe Subsequent::Mode::Sort do
  describe ".handle_input" do
    it "returns state with mode Normal when input is q" do
      state = make_state
      mock_input("q")

      expect(described_class.handle_input(state))
        .to eq(state.with(mode: Subsequent::Mode::Normal))
    end

    it "returns state unchanged when input is something else" do
      state = make_state
      mock_input("z")

      expect(described_class.handle_input(state)).to eq(state)
    end

    it "returns state with sort mode when input is f, l, or m" do
      state = make_state
      mock_input("m")

      new_sort = Subsequent::Sort::MostUncheckedItems

      expect(described_class.handle_input(state))
        .to eq(state.with(sort: new_sort, mode: Subsequent::Mode::Normal))
    end
  end
end
