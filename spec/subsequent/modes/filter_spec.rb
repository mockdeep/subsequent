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

    it "shows page indicator when multiple pages exist" do
      result = described_class.commands(state_with_tags(10))

      expect(result).to include("page 1/2")
    end

    it "hides paging hints when only one page" do
      checklist = api_checklist(name: "@tag1", check_items: [api_item])
      card = make_card(checklists: [checklist])

      result = described_class.commands(make_state(cards: [card]))

      expect(result).not_to include("page")
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

    it "advances to next page when input is >" do
      state = state_with_tags(10)
      mock_input(">")

      expect(described_class.handle_input(state).tag_page).to eq(1)
    end

    it "goes to previous page when input is <" do
      state = state_with_tags(10, tag_page: 1)
      mock_input("<")

      expect(described_class.handle_input(state).tag_page).to eq(0)
    end
  end

  def state_with_tags(count, tag_page: 0)
    cards =
      count.times.map do |i|
        checklist = api_checklist(name: "@tag#{i}", check_items: [api_item])
        make_card(id: i, checklists: [checklist])
      end
    make_state(cards:, tag_page:)
  end
end
