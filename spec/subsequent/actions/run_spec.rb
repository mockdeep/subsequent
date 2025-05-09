# frozen_string_literal: true

RSpec.describe Subsequent::Actions::Run do
  include Subsequent::Configuration::Helpers
  include Subsequent::DisplayHelpers

  def call
    input.print("q")
    input.rewind

    described_class.call
  rescue SystemExit
    # prevent exiting prematurely
  end

  def test_cards_url
    "https://api.trello.com/1/lists/test-list-id/cards?checklists=all&key=test-key&token=test-token"
  end

  def checklist_end_boilerplate
    <<~OUTPUT.strip
      sort by #{gray("first")}
      (#{cyan("1")}) toggle task
      (#{cyan("s")})ort \
      (#{cyan("o")})pen \
      (#{cyan("c")})ycle \
      (#{cyan("n")})ew
      (#{cyan("r")})efresh \
      (#{cyan("a")})rchive \
      (#{cyan("q")})uit
      #{yellow("Goodbye!")}
    OUTPUT
  end

  def end_boilerplate(sort:)
    <<~OUTPUT.strip
      sort by #{gray(sort)}
      (#{cyan("s")})ort \
      (#{cyan("o")})pen \
      (#{cyan("c")})ycle \
      (#{cyan("n")})ew
      (#{cyan("r")})efresh \
      (#{cyan("a")})rchive \
      (#{cyan("q")})uit
      #{yellow("Goodbye!")}
    OUTPUT
  end

  def stub_cards(cards)
    stub_request(:get, test_cards_url).to_return(body: cards.to_json)
  end

  def no_unchecked_items_output(card_data, sort: "first")
    <<~OUTPUT.strip
      #{card_data[:name]} - <no checklist> (#{link(card_data[:short_url])})
      ====
      No unchecked items, finish the card!

      #{end_boilerplate(sort:)}
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
      #{card_data[:name]} - Checklist (#{link(card_data[:short_url])})
      ====
      1. ☐ #{green("Check Item")}

      #{checklist_end_boilerplate}
    OUTPUT

    expect(output.string.strip).to eq(expected_output)
  end

  it "marks a checklist item as complete" do
    card_data = api_card
    card_data[:checklists].first[:check_items] = [api_checklist_item]
    stub_cards([card_data])
    put_url = "https://api.trello.com/1/cards/123/checkItem/5?key=test-key&state=complete&token=test-token"
    stub_request(:put, put_url).to_return(body: "{}")

    input.print("1")

    call

    expect(a_request(:put, put_url)).to have_been_made
  end

  it "does nothing if the number is out of range" do
    card_data = api_card
    card_data[:checklists].first[:check_items] =
      [{ pos: 1, name: "Check Item", id: 5, state: "incomplete" }]
    stub_cards([card_data])

    input.print("2")

    call

    expect(a_request(:put, /checkItem/)).not_to have_been_made
  end

  it "does nothing if the number is 0" do
    card_data = api_card
    card_data[:checklists].first[:check_items] =
      [{ pos: 1, name: "Check Item", id: 5, state: "incomplete" }]
    stub_cards([card_data])

    input.print("0")

    call

    expect(a_request(:put, /checkItem/)).not_to have_been_made
  end

  it "does nothing if a non-option key is pressed" do
    card_data = api_card
    card_data[:checklists].first[:check_items] =
      [{ pos: 1, name: "Check Item", id: 5, state: "incomplete" }]
    stub_cards([card_data])

    input.print("z")

    call

    expect(a_request(:put, /checkItem/)).not_to have_been_made
  end

  context "when mode is :sort" do
    it "sorts the cards by first" do
      card_data = api_card
      stub_cards([card_data])

      input.print("sf")

      call

      expect(output.string.strip).to eq(no_unchecked_items_output(card_data))
    end

    it "sorts the cards by most checklist items" do
      card_data = api_card
      stub_cards([card_data])

      input.print("sm")

      call

      sort = "most_unchecked_items"
      expect(output.string.strip)
        .to eq(no_unchecked_items_output(card_data, sort:))
    end

    it "sorts the cards by least checklist items" do
      card_data = api_card
      stub_cards([card_data])

      input.print("sl")

      call

      sort = "least_unchecked_items"
      expect(output.string.strip)
        .to eq(no_unchecked_items_output(card_data, sort:))
    end
  end

  it "cycles the checklist item" do
    card_data = api_card
    card_data[:checklists].first[:check_items] =
      [{ pos: 1, name: "Check Item", id: 5, state: "incomplete" }]
    stub_cards([card_data])
    put_url = "https://api.trello.com/1/cards/123/checkItem/5?key=test-key&pos=2&token=test-token"
    stub_request(:put, put_url).to_return(body: "{}")

    input.print("ci")
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

    input.print("cl")
    call

    expect(a_request(:put, put_url)).to have_been_made
  end

  it "cycles the card" do
    card_data = api_card
    card_data[:checklists].first[:check_items] =
      [{ pos: 1, name: "Check Item", id: 5, state: "incomplete" }]
    stub_cards([card_data])
    put_url = "https://api.trello.com/1/cards/123?key=test-key&pos=2&token=test-token"
    stub_request(:put, put_url).to_return(body: "{}")

    input.print("cc")
    call

    expect(a_request(:put, put_url)).to have_been_made
  end

  it "backs out of cycle mode" do
    card_data = api_card
    card_data[:checklists].first[:check_items] =
      [{ pos: 1, name: "Check Item", id: 5, state: "incomplete" }]
    stub_cards([card_data])

    input.print("cq")

    call

    expected_output = <<~OUTPUT.strip
      #{card_data[:name]} - Checklist (#{link(card_data[:short_url])})
      ====
      1. ☐ #{green("Check Item")}

      #{checklist_end_boilerplate}
    OUTPUT
    expect(output.string.strip).to eq(expected_output)
  end

  it "creates a new card" do
    input.print("nc")
    input.puts("New Card")
    input.puts("New Checklist")
    input.puts("New Checklist Item")
    input.puts("q")
    stub_cards([api_card])

    card_post_url = "https://api.trello.com/1/cards?idList=test-list-id&key=test-key&name=New%20Card&pos=top&token=test-token"
    checklist_post_url = "https://api.trello.com/1/checklists?idCard=123&key=test-key&name=New%20Checklist&pos=top&token=test-token"
    checklist_item_post_url = "https://api.trello.com/1/checklists/456/checkItems?key=test-key&name=New%20Checklist%20Item&pos=top&token=test-token"
    stub_request(:post, card_post_url)
    stub_request(:post, checklist_post_url)
    stub_request(:post, checklist_item_post_url)

    call

    expect(a_request(:post, card_post_url)).to have_been_made
    expect(a_request(:post, checklist_post_url)).to have_been_made
    expect(a_request(:post, checklist_item_post_url)).to have_been_made
  end

  it "creates a new list on the current card" do
    input.print("nl")
    input.puts("New Checklist")
    input.puts("New Checklist Item")
    input.puts("q")
    stub_cards([api_card])

    checklist_post_url = "https://api.trello.com/1/checklists?idCard=123&key=test-key&name=New%20Checklist&pos=top&token=test-token"
    checklist_item_post_url = "https://api.trello.com/1/checklists/456/checkItems?key=test-key&name=New%20Checklist%20Item&pos=top&token=test-token"
    stub_request(:post, checklist_post_url)
    stub_request(:post, checklist_item_post_url)

    call

    expect(a_request(:post, checklist_post_url)).to have_been_made
    expect(a_request(:post, checklist_item_post_url)).to have_been_made
  end

  it "creates a new checklist item on the current checklist" do
    card_data = api_card
    card_data[:checklists].first[:check_items] = [api_checklist_item]
    stub_cards([card_data])

    input.print("ni")
    input.puts("New Checklist Item")
    input.puts("q")

    checklist_item_post_url = "https://api.trello.com/1/checklists/456/checkItems?key=test-key&name=New%20Checklist%20Item&pos=top&token=test-token"
    stub_request(:post, checklist_item_post_url)

    call

    expect(a_request(:post, checklist_item_post_url)).to have_been_made
  end

  it "opens links for checklist items" do
    card_data = api_card
    name = "foo https://example.com bar https://example.org baz"
    card_data[:checklists].first[:check_items] =
      [{ pos: 1, name:, id: 5, state: "incomplete" }]
    stub_cards([card_data])

    allow(Subsequent::Commands::OpenLinks).to receive(:system).twice

    input.print("o")
    call

    expect(Subsequent::Commands::OpenLinks)
      .to have_received(:system).with("open", "https://example.com").ordered
    expect(Subsequent::Commands::OpenLinks)
      .to have_received(:system).with("open", "https://example.org").ordered
  end

  it "opens the card's short URL when there are no checklist items" do
    card_data = api_card
    card_data[:checklists].first[:check_items] = []
    stub_cards([card_data])

    allow(Subsequent::Commands::OpenLinks).to receive(:system)

    input.print("o")
    call

    expect(Subsequent::Commands::OpenLinks)
      .to have_received(:system).with("open", "http://example.com")
  end

  it "archives the card" do
    card_data = api_card
    stub_cards([card_data])
    put_url = "https://api.trello.com/1/cards/123?key=test-key&closed=true&token=test-token"
    stub_request(:put, put_url).to_return(body: "{}")

    input.print("ay")
    call

    expect(a_request(:put, put_url)).to have_been_made
  end

  it "does not archive the card when user cancels" do
    card_data = api_card
    stub_cards([card_data])
    put_url = "https://api.trello.com/1/cards/123?key=test-key&closed=true&token=test-token"
    stub_request(:put, put_url).to_return(body: "{}")

    input.print("an")

    call

    expect(a_request(:put, put_url)).not_to have_been_made
  end
end
