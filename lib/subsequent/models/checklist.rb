# frozen_string_literal: true

class Subsequent::Models::Checklist
  attr_accessor :id, :items, :pos

  def self.from_data(checklists_data, card:)
    checklists_data
      .map { |checklist_data| new(card_id: card.id, **checklist_data) }
      .sort
  end

  def initialize(card_id:, id:, check_items:, pos:, **_checklist_data)
    self.id = id
    self.pos = pos
    self.items =
      Subsequent::Models::ChecklistItem.from_data(check_items, card_id:)
  end

  def <=>(other)
    pos <=> other.pos
  end

  def unchecked_items?
    unchecked_items.any?
  end

  def unchecked_items
    items.reject(&:checked?)
  end
end
