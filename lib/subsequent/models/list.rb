# frozen_string_literal: true

Subsequent::Models::List = Data.define(:id, :name)

# class to encapsulate a list
class Subsequent::Models::List
  def initialize(id:, name:, **_list_data)
    super(id:, name:)
  end
end
