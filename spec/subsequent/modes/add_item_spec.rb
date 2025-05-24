# frozen_string_literal: true

RSpec.describe Subsequent::Modes::AddItem do
  include Subsequent::DisplayHelpers

  describe ".commands" do
    it "returns command to add item when checklist is present" do
      state = make_state(checklist: make_checklist)
      text1 = "add new (#{cyan("c")})ard, " \
              "check(#{cyan("l")})ist or (#{cyan("i")})tem"
      text2 = "(#{cyan("q")}) to cancel"

      expect(described_class.commands(state)).to eq("#{text1}\n#{text2}")
    end

    it "returns commands to add card or checklist when checklist not present" do
      state = make_state
      text1 = "add new (#{cyan("c")})ard or check(#{cyan("l")})ist"
      text2 = "(#{cyan("q")}) to cancel"

      expect(described_class.commands(state)).to eq("#{text1}\n#{text2}")
    end
  end

  describe ".handle_input" do
    it "returns state with mode AddCard when input is c" do
      state = make_state
      input.print("c")
      input.rewind

      expect(described_class.handle_input(state))
        .to eq(state.with(mode: Subsequent::Modes::AddCard))
    end

    it "returns state with mode AddChecklist when input is l" do
      state = make_state
      input.print("l")
      input.rewind

      expect(described_class.handle_input(state))
        .to eq(state.with(mode: Subsequent::Modes::AddChecklist))
    end

    it "returns state with mode AddChecklistItem when input is i" do
      state = make_state(cards: [make_card_with_item])
      input.print("i")
      input.rewind

      expect(described_class.handle_input(state))
        .to eq(state.with(mode: Subsequent::Modes::AddChecklistItem))
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
        .to eq(state.with(mode: Subsequent::Modes::Normal))
    end

    it "returns state unchanged when input is something else" do
      state = make_state
      input.print("z")
      input.rewind

      expect(described_class.handle_input(state)).to eq(state)
    end
  end
end
