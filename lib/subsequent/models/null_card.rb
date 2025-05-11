# frozen_string_literal: true

# class to represent a null card
class Subsequent::Models::NullCard
  # returns an empty array
  def checklists
    []
  end

  # returns a null card name
  def name
    "<No card>"
  end

  # return nil
  def short_url; end
end
