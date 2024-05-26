# frozen_string_literal: true

class Subsequent::Models::Checklist
  attr_accessor :id, :items, :pos

  def initialize(card_id:, id:, check_items:, pos:, **_checklist_data)
    self.id = id
    self.pos = pos
    self.items = check_items.map do |item_data|
      Subsequent::Models::ChecklistItem.new(card_id:, **item_data)
    end.sort
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
