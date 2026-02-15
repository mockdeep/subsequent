# frozen_string_literal: true

# class to encapsulate a checklist
class Subsequent::Models::Checklist
  attr_accessor :card, :id, :items, :name, :pos

  class << self
    # Create a new array of checklists from the given data
    def from_data(checklists_data, card:)
      checklists_data.map { |checklist_data| new(card:, **checklist_data) }.sort
    end
  end

  def initialize(card:, id:, check_items:, name:, pos:, **_checklist_data)
    self.card = card
    self.id = id
    self.name = name
    self.pos = pos
    self.items =
      Subsequent::Models::ChecklistItem.from_data(check_items, card_id: card.id)
  end

  # compare the position of this checklist with another
  def <=>(other)
    pos <=> other.pos
  end

  # return whether the checklist has unchecked items
  def unchecked_items?
    unchecked_items.any?
  end

  # return the unchecked items in the checklist
  def unchecked_items
    items.reject(&:checked?)
  end

  # return true if the checklist has the same id as another checklist
  def eql?(other)
    id == other.id
  end

  # return the hash of the checklist id
  def hash
    id.hash
  end

  # return a list of tag name strings from the checklist name
  def tag_names
    names = name.split.select { |word| word.start_with?("@") }
    names << "<no tag>" if names.empty?
    names
  end
end
