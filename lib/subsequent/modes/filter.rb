# frozen_string_literal: true

# filter to return cards with a specific tag
module Subsequent::Modes::Filter
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  # filter mode commands
  def self.commands(state)
    state => { cards: }

    tags = cards.flat_map(&:tags).uniq.sort

    [
      "select tag to filter by",
      "(#{cyan("n")})one",
      *tags.each_with_index.map do |tag, index|
        "(#{cyan(index + 1)}) #{tag}"
      end,
      "(#{cyan("q")}) to cancel",
    ]
  end

  # handle input for filter mode
  def self.handle_input(state)
    tags = state.cards.flat_map(&:tags).uniq.sort

    process_input(state) do |char|
      case char
      when "n"
        fetch(Subsequent::Filters::None, state)
      when *("1"..tags.size.to_s).to_a
        fetch(Subsequent::Filters::Tag.new(tags[Integer(char) - 1]), state)
      end
    end
  end

  # fetch cards based on the filter and sort
  def self.fetch(filter, state)
    Subsequent::Commands::FetchData.call(filter:, sort: state.sort)
  end

  # process input for filter mode
  def self.process_input(state)
    char = input.getch

    result = yield(char)

    return result if result

    case char
    when "q", "\u0004", "\u0003"
      state.with(mode: Subsequent::Modes::Normal)
    else
      state
    end
  end
end
