# frozen_string_literal: true

# class to encapsulate a card
class Subsequent::Models::Card
  attr_accessor :checklists, :id, :name, :pos, :short_url

  def initialize(id:, name:, pos:, short_url:, checklists:, **_card_data)
    self.id = id
    self.pos = pos
    self.checklists =
      Subsequent::Models::Checklist.from_data(checklists, card: self)
    self.name = name
    self.short_url = short_url
  end

  # returns true if the cards have the same id
  def ==(other)
    id == other.id
  end

  # return a unique list of tags from all checklists
  def tags
    checklists.select(&:unchecked_items?).flat_map(&:tags).uniq
  end
end
