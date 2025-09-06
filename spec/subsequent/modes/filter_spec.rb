# frozen_string_literal: true

RSpec.describe Subsequent::Modes::Filter do
  include Subsequent::DisplayHelpers

  describe ".commands" do
    it "returns a list of commands with tags" do
      checklist = api_checklist(name: "@tag1", check_items: [api_item])
      card = make_card(checklists: [checklist])

      expect(described_class.commands(make_state(cards: [card])))
        .to include("(#{cyan("1")}) @tag1")
    end
  end

  describe ".handle_input" do
    it "returns state with mode Normal when input is q" do
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

    it "returns state with filter None when input is n" do
      state = make_state(filter: Subsequent::Filters::Tag.new(make_tag))
      mock_input("n")
      stub_request(:get, /cards/).to_return(body: "{}")

      new_state = described_class.handle_input(state)

      expect(new_state.filter).to eq(Subsequent::Filters::None)
    end

    it "returns state with filter Tag when input is a number" do
      checklist = api_checklist(name: "@tag1", check_items: [api_item])
      card = make_card(checklists: [checklist])
      mock_input("1")
      stub_request(:get, /cards/).to_return(body: "{}")

      new_state = described_class.handle_input(make_state(cards: [card]))

      expect(new_state.filter).to eq(Subsequent::Filters::Tag.new("@tag1"))
    end

    it "returns state unchanged when input is not a valid tag" do
      state = make_state
      mock_input("3")

      expect(described_class.handle_input(state)).to eq(state)
    end
  end
end
