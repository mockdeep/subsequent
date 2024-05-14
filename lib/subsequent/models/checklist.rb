class Subsequent::Models::Checklist
  attr_accessor :items

  def initialize(card_id:, check_items:, **checklist_data)
    self.items = check_items.map do |item_data|
      Subsequent::Models::ChecklistItem.new(card_id:, **item_data)
    end.sort
  end

  def unchecked_items?
    unchecked_items.any?
  end

  def unchecked_items
    items.reject(&:checked?)
  end
end
