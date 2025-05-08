# frozen_string_literal: true

# class to represent a null checklist
class Subsequent::Models::NullChecklist
  # return a null checklist name
  def name
    "<no checklist>"
  end

  # return an empty array of items
  def unchecked_items
    []
  end

  # return false
  def present?
    false
  end

  # return true if the object is a null checklist
  def ==(other)
    other.is_a?(self.class)
  end
end
