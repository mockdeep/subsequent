# frozen_string_literal: true

RSpec.describe Subsequent::Actions::Run do
  include Subsequent::DisplayHelpers

  def call
    input.print("q")
    input.rewind

    described_class.call
  rescue SystemExit
    # prevent exiting prematurely
  end

  def checklist_end_boilerplate
    <<~OUTPUT.strip
      sort by #{gray("first")}
      (#{cyan("1")}) toggle task
      (#{cyan("f")})ilter (#{cyan("s")})ort (#{cyan("o")})pen \
      (#{cyan("c")})ycle (#{cyan("n")})ew
      (#{cyan("r")})efresh (#{cyan("b")})rowse \
      (#{cyan("a")})rchive (#{cyan("q")})uit#{terminal_title("")}
      #{yellow("Goodbye!")}
    OUTPUT
  end

  def end_boilerplate(sort:)
    <<~OUTPUT.strip
      sort by #{gray(sort)}

      (#{cyan("f")})ilter (#{cyan("s")})ort (#{cyan("o")})pen \
      (#{cyan("c")})ycle (#{cyan("n")})ew
      (#{cyan("r")})efresh (#{cyan("b")})rowse \
      (#{cyan("a")})rchive (#{cyan("q")})uit#{terminal_title("")}
      #{yellow("Goodbye!")}
    OUTPUT
  end

  def stub_cards(cards)
    test_url = api_url("lists/test-list-id/cards", checklists: "all")
    stub_request(:get, test_url).to_return(body: cards.to_json)
  end

  def no_unchecked_items_output(card_data, sort: "first")
    name = card_data.fetch(:name)

    <<~OUTPUT.strip
      #{terminal_title(name)}#{name} - <no checklist> (#{link(card_data.fetch(:short_url))})
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
    card_data.fetch(:checklists).first[:check_items] =
      [{ pos: 1, name: "Check Item", id: 5, state: "incomplete" }]
    stub_cards([card_data])

    call

    name = card_data.fetch(:name)
    expected_output = <<~OUTPUT.strip
      #{terminal_title(name)}#{name} - Checklist (#{link(card_data.fetch(:short_url))})
      ====
      1. ☐ #{green("Check Item")}

      #{checklist_end_boilerplate}
    OUTPUT

    expect(output.string.strip).to eq(expected_output)
  end

  it "marks a checklist item as complete" do
    card_data = api_card
    card_data.fetch(:checklists).first[:check_items] = [api_item]
    stub_cards([card_data])
    put_url = api_url("cards/123/checkItem/5", state: "complete")
    stub_request(:put, put_url).to_return(body: "{}")

    input.print("1")

    call

    expect(a_request(:put, put_url)).to have_been_made
  end

  it "does nothing if the number is out of range" do
    card_data = api_card
    card_data.fetch(:checklists).first[:check_items] =
      [{ pos: 1, name: "Check Item", id: 5, state: "incomplete" }]
    stub_cards([card_data])

    input.print("2")

    call

    expect(a_request(:put, /checkItem/)).not_to have_been_made
  end

  it "does nothing if the number is 0" do
    card_data = api_card
    card_data.fetch(:checklists).first[:check_items] =
      [{ pos: 1, name: "Check Item", id: 5, state: "incomplete" }]
    stub_cards([card_data])

    input.print("0")

    call

    expect(a_request(:put, /checkItem/)).not_to have_been_made
  end

  it "does nothing if a non-option key is pressed" do
    card_data = api_card
    card_data.fetch(:checklists).first[:check_items] =
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
    card_data.fetch(:checklists).first[:check_items] =
      [{ pos: 1, name: "Check Item", id: 5, state: "incomplete" }]
    stub_cards([card_data])
    put_url = api_url("cards/123/checkItem/5", pos: 2)
    stub_request(:put, put_url).to_return(body: "{}")

    input.print("ci")
    call

    expect(a_request(:put, put_url)).to have_been_made
  end

  it "cycles the checklist" do
    card_data = api_card
    card_data.fetch(:checklists).first[:check_items] =
      [{ pos: 1, name: "Check Item", id: 5, state: "incomplete" }]
    stub_cards([card_data])
    put_url = api_url("checklist/456", pos: 2)
    stub_request(:put, put_url).to_return(body: "{}")

    input.print("cl")
    call

    expect(a_request(:put, put_url)).to have_been_made
  end

  it "cycles the card" do
    card_data = api_card
    card_data.fetch(:checklists).first[:check_items] =
      [{ pos: 1, name: "Check Item", id: 5, state: "incomplete" }]
    stub_cards([card_data])
    put_url = api_url("cards/123", pos: 2)
    stub_request(:put, put_url).to_return(body: "{}")

    input.print("cc")
    call

    expect(a_request(:put, put_url)).to have_been_made
  end

  it "backs out of cycle mode" do
    card_data = api_card
    card_data.fetch(:checklists).first[:check_items] =
      [{ pos: 1, name: "Check Item", id: 5, state: "incomplete" }]
    stub_cards([card_data])

    input.print("cq")

    call

    name = card_data.fetch(:name)
    expected_output = <<~OUTPUT.strip
      #{terminal_title(name)}#{name} - Checklist (#{link(card_data.fetch(:short_url))})
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
    input.puts("New Item")
    input.puts("q")
    stub_cards([api_card])

    card_post_url =
      api_url("cards", idList: "test-list-id", name: "New Card", pos: "top")
    checklist_post_url =
      api_url("checklists", idCard: "123", name: "New Checklist", pos: "top")
    checklist_item_post_url =
      api_url("checklists/456/checkItems", name: "New Item", pos: "top")
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
    input.puts("New Item")
    input.puts("q")
    stub_cards([api_card])

    checklist_post_url =
      api_url("checklists", idCard: "123", name: "New Checklist", pos: "top")
    checklist_item_post_url =
      api_url("checklists/456/checkItems", name: "New Item", pos: "top")
    stub_request(:post, checklist_post_url)
    stub_request(:post, checklist_item_post_url)

    call

    expect(a_request(:post, checklist_post_url)).to have_been_made
    expect(a_request(:post, checklist_item_post_url)).to have_been_made
  end

  it "creates a new checklist item on the current checklist" do
    card_data = api_card
    card_data.fetch(:checklists).first[:check_items] = [api_item]
    stub_cards([card_data])

    input.print("ni")
    input.puts("New Item")
    input.puts("q")

    checklist_item_post_url =
      api_url("checklists/456/checkItems", name: "New Item", pos: "top")
    stub_request(:post, checklist_item_post_url)

    call

    expect(a_request(:post, checklist_item_post_url)).to have_been_made
  end

  it "opens links for checklist items" do
    card_data = api_card
    name = "foo https://example.com bar https://example.org baz"
    card_data.fetch(:checklists).first[:check_items] =
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
    card_data.fetch(:checklists).first[:check_items] = []
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
    put_url = api_url("cards/123", closed: true)
    stub_request(:put, put_url).to_return(body: "{}")

    input.print("ay")
    call

    expect(a_request(:put, put_url)).to have_been_made
  end

  it "does not archive the card when user cancels" do
    card_data = api_card
    stub_cards([card_data])
    put_url = api_url("cards/123", closed: true)
    stub_request(:put, put_url).to_return(body: "{}")

    input.print("an")

    call

    expect(a_request(:put, put_url)).not_to have_been_made
  end

  it "does not clear screen when debug is enabled" do
    Subsequent::Configuration.debug = true
    card_data = api_card
    stub_cards([card_data])
    allow(output).to receive(:clear_screen)

    call

    expect(output).not_to have_received(:clear_screen)
  ensure
    Subsequent::Configuration.debug = false
  end
end
