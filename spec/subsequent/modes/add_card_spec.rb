# frozen_string_literal: true

RSpec.describe Subsequent::Modes::AddCard do
  it "returns state to normal mode with the same card" do
    input.puts("Card Name")
    input.puts("q")

    state = make_state
    expect(described_class.handle_input(state))
      .to eq(state.with(mode: Subsequent::Modes::Normal))
  end

  it "returns state with normal mode when input is empty" do
    state = make_state
    expect(described_class.handle_input(state))
      .to eq(state.with(mode: Subsequent::Modes::Normal))
  end

  it "returns state with normal mode when input is q" do
    input.puts("q")

    state = make_state
    expect(described_class.handle_input(state))
      .to eq(state.with(mode: Subsequent::Modes::Normal))
  end
end
