# frozen_string_literal: true

# class to encapsulate a checklist item
class Subsequent::Models::ChecklistItem
  attr_accessor :card_id, :id, :name, :pos, :state

  class << self
    # create a new array of checklist items from the given data
    def from_data(checklist_items_data, card_id:)
      checklist_items_data.map { |item_data| new(card_id:, **item_data) }.sort
    end
  end

  def initialize(card_id:, id:, name:, pos:, state:, **_item_data)
    self.card_id = card_id
    self.id = id
    self.name = name
    self.state = state
    self.pos = pos
  end

  # compare the position of this checklist item with another
  def <=>(other)
    pos <=> other.pos
  end

  # return whether the checklist item is checked
  def checked?
    state == "complete"
  end

  # return the links in the checklist item name
  def links
    name.scan(%r{https?://\S+})
  end
end
