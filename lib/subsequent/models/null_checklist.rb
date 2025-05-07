# frozen_string_literal: true

# class to represent a null checklist
class Subsequent::Models::NullChecklist
  # return an empty array of items
  def unchecked_items
    []
  end

  # return false
  def present?
    false
  end
end
