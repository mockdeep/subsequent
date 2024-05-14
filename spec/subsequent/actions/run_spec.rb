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
    { id: "123", name: "blah", short_url: "http://example.com", checklists: [api_checklist] }
  end

  def test_cards_url
    "https://api.trello.com/1/lists/test-list-id/cards?checklists=all&key=test-key&token=test-token"
  end

  def end_boilerplate
    <<~OUTPUT.strip
      #{cyan("r")} to refresh
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
end
