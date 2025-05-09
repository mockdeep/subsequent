# frozen_string_literal: true

RSpec.describe Subsequent::Mode::AddItem do
  include Subsequent::DisplayHelpers
  include Subsequent::Configuration::Helpers

  describe ".commands" do
    it "returns command to add item when checklist is present" do
      state = { checklist: true }
      text1 = "add new (#{cyan("c")})ard, " \
              "check(#{cyan("l")})ist or (#{cyan("i")})tem"
      text2 = "(#{cyan("q")}) to cancel"

      expect(described_class.commands(state)).to eq([text1, text2])
    end

    it "returns commands to add card or checklist when checklist not present" do
      state = { checklist: false }
      text1 = "add new (#{cyan("c")})ard or check(#{cyan("l")})ist"
      text2 = "(#{cyan("q")}) to cancel"

      expect(described_class.commands(state)).to eq([text1, text2])
    end
  end

  describe ".handle_input" do
    it "returns state with mode AddCard when input is c" do
      state = make_state
      input.print("c")
      input.rewind

      expect(described_class.handle_input(state))
        .to eq(state.with(mode: Subsequent::Mode::AddCard))
    end

    it "returns state with mode AddChecklist when input is l" do
      state = make_state
      input.print("l")
      input.rewind

      expect(described_class.handle_input(state))
        .to eq(state.with(mode: Subsequent::Mode::AddChecklist))
    end

    it "returns state with mode AddChecklistItem when input is i" do
      state = make_state(checklist: true)
      input.print("i")
      input.rewind

      expect(described_class.handle_input(state))
        .to eq(state.with(mode: Subsequent::Mode::AddChecklistItem))
    end

    it "returns state unchanged when no items and input is i" do
      state = make_state
      input.print("i")
      input.rewind

      expect(described_class.handle_input(state)).to eq(state)
    end

    it "returns state with mode Normal when input is q" do
      state = make_state
      input.print("q")
      input.rewind

      expect(described_class.handle_input(state))
        .to eq(state.with(mode: Subsequent::Mode::Normal))
    end

    it "returns state unchanged when input is something else" do
      state = make_state
      input.print("z")
      input.rewind

      expect(described_class.handle_input(state)).to eq(state)
    end
  end
end
