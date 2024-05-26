module Subsequent::Actions::Run

  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  def self.call
    sort = Subsequent::Sort::First
    state = show_spinner { Subsequent::Commands::FetchData.call(sort:) }

    loop do
      state => { card:, checklist:, checklist_items:, mode: }

      output.clear_screen
      output.puts "#{card.name} (#{link(card.short_url)})"
      output.puts "=" * card.name.size
      if checklist
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
      output.puts mode.commands(state)

      state = mode.handle_input(state)
    end
  end
end
