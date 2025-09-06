# frozen_string_literal: true

# class to encapsulate a tag
class Subsequent::Models::Tag
  attr_accessor :checklists, :name

  class << self
    # finds or creates a tag with the given name
    def find_or_create(name)
      @tags ||= []
      tag = @tags.find { |tag| tag.name == name }

      unless tag
        tag = new(name)
        @tags << tag
      end

      tag
    end

    # clear the list of tags
    def clear
      @tags = []
    end
  end

  def initialize(name)
    self.name = name
    self.checklists = Set.new
  end

  # add a checklist to the tag
  def add_checklist(checklist)
    # remove existing copy if present to ensure freshest reference
    checklists.delete(checklist)
    checklists.add(checklist)
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
