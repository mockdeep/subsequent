# frozen_string_literal: true

RSpec.describe Subsequent::Actions::Run do
  include Subsequent::Configuration::Helpers
  include Subsequent::TextFormatting

  def call
    input.puts("q")
    input.rewind

    described_class.call
  rescue SystemExit
    # prevent exiting prematurely
  end

  def api_checklist
    { id: "456", name: "Checklist", pos: 1, check_items: [] }
  end

  def api_card
    { id: "123", name: "blah", pos: 5, short_url: "http://example.com", checklists: [api_checklist] }
  end

  def test_cards_url
    "https://api.trello.com/1/lists/test-list-id/cards?checklists=all&key=test-key&token=test-token"
  end

  def checklist_end_boilerplate
    <<~OUTPUT.strip
      #{cyan("1")} to toggle task
      #{cyan("r")} to refresh
      #{cyan("c")} to cycle
      #{cyan("o")} to open links
      #{cyan("q")} to quit
      #{yellow("Goodbye!")}
    OUTPUT
  end

  def end_boilerplate
    <<~OUTPUT.strip
      #{cyan("r")} to refresh
      #{cyan("c")} to cycle
      #{cyan("o")} to open links
      #{cyan("q")} to quit
      #{yellow("Goodbye!")}
    OUTPUT
  end

  def stub_cards(cards)
    stub_request(:get, test_cards_url).to_return(body: cards.to_json)
  end

  def no_unchecked_items_output(card_data)
    <<~OUTPUT.strip
      #{card_data[:name]} (#{link(card_data[:short_url])})
      ====
      No unchecked items, finish the card!

      #{end_boilerplate}
    OUTPUT
  end

  it "displays a card with no unchecked checklist items" do
    stub_cards([api_card])

    call

    expect(output.string.strip).to eq(no_unchecked_items_output(api_card))
  end

  it "displays a card with unchecked checklist items" do
    card_data = api_card
    card_data[:checklists].first[:check_items] =
      [{ pos: 1, name: "Check Item", id: 5, state: "incomplete" }]
    stub_cards([card_data])

    call

    expected_output = <<~OUTPUT.strip
      #{card_data[:name]} (#{link(card_data[:short_url])})
      ====
      1. ☐ #{green("Check Item")}

      #{checklist_end_boilerplate}
    OUTPUT

    expect(output.string.strip).to eq(expected_output)
  end

  it "cycles the checklist item" do
    card_data = api_card
    card_data[:checklists].first[:check_items] =
      [{ pos: 1, name: "Check Item", id: 5, state: "incomplete" }]
    stub_cards([card_data])
    put_url = "https://api.trello.com/1/cards/123/checkItem/5?key=test-key&pos=2&token=test-token"
    stub_request(:put, put_url).to_return(body: "{}")

    input.puts("ci")
    call

    expect(a_request(:put, put_url)).to have_been_made
  end

  it "cycles the checklist" do
    card_data = api_card
    card_data[:checklists].first[:check_items] =
      [{ pos: 1, name: "Check Item", id: 5, state: "incomplete" }]
    stub_cards([card_data])
    put_url = "https://api.trello.com/1/checklist/456?key=test-key&pos=2&token=test-token"
    stub_request(:put, put_url).to_return(body: "{}")

    input.puts("cl")
    call

    expect(a_request(:put, put_url)).to have_been_made
  end

  it "cycles the card" do
    card_data = api_card
    card_data[:checklists].first[:check_items] =
      [{ pos: 1, name: "Check Item", id: 5, state: "incomplete" }]
    stub_cards([card_data])
    put_url = "https://api.trello.com/1/cards/123?key=test-key&pos=6&token=test-token"
    stub_request(:put, put_url).to_return(body: "{}")

    input.puts("cc")
    call

    expect(a_request(:put, put_url)).to have_been_made
  end

  it "opens links for checklist items" do
    card_data = api_card
    name = "foo https://example.com bar https://example.org baz"
    card_data[:checklists].first[:check_items] =
      [{ pos: 1, name:, id: 5, state: "incomplete" }]
    stub_cards([card_data])

    allow(described_class).to receive(:system).twice

    input.puts("o")
    call

    expect(described_class)
      .to have_received(:system).with("open", "https://example.com").ordered
    expect(described_class)
      .to have_received(:system).with("open", "https://example.org").ordered
  end

  it "opens the card's short URL when there are no checklist items" do
    card_data = api_card
    card_data[:checklists].first[:check_items] = []
    stub_cards([card_data])

    allow(described_class).to receive(:system)

    input.puts("o")
    call

    expect(described_class)
      .to have_received(:system).with("open", "http://example.com")
  end
end
