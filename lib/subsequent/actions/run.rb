module Subsequent::Actions::Run

  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  def self.call
    sort = Subsequent::Sort::First
    state = show_spinner { Subsequent::Commands::FetchData.call(sort:) }

    loop do
      state => { card:, checklist:, checklist_items: }

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
      output.puts commands(state)

      state = handle_input(state)
    end
  end

  def self.commands(state)
    state => { mode: }

    case mode
    when :normal
      Subsequent::Mode::Normal.commands(state)
    when :cycle
      Subsequent::Mode::Cycle.commands(state)
    when :sort
      Subsequent::Mode::Sort.commands(state)
    end
  end

  def self.handle_input(state)
    state => { checklist_items:, mode:, sort: }

    if mode == :cycle
      return cycle(state)
    elsif mode == :sort
      return Subsequent::Mode::Sort.handle_input(state)
    end

    char = input.getch

    case char
    when ("1"..checklist_items.to_a.size.to_s)
      Subsequent::Commands::ToggleChecklistItem.call(state, char)
    when "r"
      show_spinner { Subsequent::Commands::FetchData.call(sort:) }
    when "s"
      Subsequent::State.new(**state.to_h, mode: :sort)
    when "c"
      Subsequent::State.new(**state.to_h, mode: :cycle)
    when "o"
      Subsequent::Commands::OpenLinks.call(state)
    when "a"
      Subsequent::Commands::ArchiveCard.call(state)
    when "q", "\u0004", "\u0003"
      output.puts yellow("Goodbye!")
      exit
    else
      state
    end
  end

  def self.cycle(state)
    state => { cards:, card:, checklist:, checklist_items:, sort: }

    char = input.getch

    case char
    when "q", "\u0004", "\u0003"
      Subsequent::State.new(**state.to_h, mode: :normal)
    when "i"
      checklist_item = checklist_items.first
      pos = checklist.items.last.pos + 1
      show_spinner do
        Subsequent::TrelloClient.update_checklist_item(checklist_item, pos:)
        Subsequent::Commands::FetchData.call(sort:)
      end
    when "l"
      pos = card.checklists.last.pos + 1

      show_spinner do
        Subsequent::TrelloClient.update_checklist(checklist, pos:)
        Subsequent::Commands::FetchData.call(sort:)
      end
    when "c"
      pos = cards.last.pos + 1

      show_spinner do
        Subsequent::TrelloClient.update_card(card, pos:)
        Subsequent::Commands::FetchData.call(sort:)
      end
    else
      state
    end
  end
end
