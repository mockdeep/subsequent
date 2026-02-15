# frozen_string_literal: true

Subsequent::Models::Card =
  Data.define(:checklists, :id, :name, :pos, :short_url)

# class to encapsulate a card
class Subsequent::Models::Card
  def initialize(id:, name:, pos:, short_url:, checklists:, **_card_data)
    super(
      checklists: build_checklists(checklists, card_id: id),
      id:,
      name:,
      pos:,
      short_url:,
    )
  end

  private

  def build_checklists(checklists, card_id:)
    return checklists if checklists.all?(Subsequent::Models::Checklist)

    Subsequent::Models::Checklist.from_data(checklists, card_id:)
  end
end
