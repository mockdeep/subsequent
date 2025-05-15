# frozen_string_literal: true

# module that runs the application
module Subsequent::Actions::Run
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  # Run the application
  def self.call(*args)
    Subsequent::Configuration.parse(args)
    sort = Subsequent::Sorts::First
    filter = Subsequent::Filters::None
    state =
      show_spinner do
        Subsequent::Commands::FetchData.call(filter:, sort:)
      end

    loop do
      state => { card:, checklist_items:, mode: }

      output.clear_screen unless debug?
      output.puts title(state)
      output.puts "=" * card.name.size
      if checklist_items.any?
        checklist_items.each_with_index do |item, index|
          icon = item.checked? ? "✔" : "☐"
          item_name = linkify(item.name)
          name = item.checked? ? gray(item_name) : green(item_name)
          output.puts "#{index + 1}. #{icon} #{name}"
        end
      else
        output.puts "No unchecked items, finish the card!"
      end

      output.puts
      output.print(mode.commands(state).join("\n"))

      state = mode.handle_input(state)
    end
  end

  # title to display
  def self.title(state)
    state => { card:, checklist: }

    "#{card.name} - #{checklist.name} (#{link(card.short_url)})"
  end
end
