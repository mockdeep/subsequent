# frozen_string_literal: true

# class to encapsulate a tag
class Subsequent::Models::Tag
  attr_reader :checklists, :name

  def initialize(name, checklists: [])
    @name = name
    @checklists = checklists
  end

  # return a list of all unchecked items in all checklists with this tag
  def items
    checklists.flat_map(&:unchecked_items)
  end

  # return the tag name and number of items
  def to_s
    "#{name} (#{items.size})"
  end

  # return true if the tag name is the same as another tag or string
  def ==(other)
    other.is_a?(String) ? name == other : other.name == name
  end

  # compare the name of this tag with another tag
  def <=>(other)
    name <=> other.name
  end
end
