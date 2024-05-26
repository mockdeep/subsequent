module Subsequent::Actions::Run

  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  def self.call
    state = fetch_data(sort: Subsequent::Sort::First)

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

  def self.fetch_data(sort:)
    Subsequent::State.format(cards: load_cards, sort:)
  end

  def self.load_cards
    show_spinner { Subsequent::TrelloClient.fetch_cards }
  end

  def self.handle_input(state)
    state => { checklist_items:, mode:, sort: }

    if mode == :cycle
      return cycle(state)
    elsif mode == :sort
      return sort(state)
    end

    char = input.getch

    case char
    when ("1"..checklist_items.to_a.size.to_s)
      Subsequent::Commands::ToggleChecklistItem.call(state, char)
    when "r"
      fetch_data(sort:)
    when "s"
      Subsequent::State.new(**state.to_h, mode: :sort)
    when "c"
      Subsequent::State.new(**state.to_h, mode: :cycle)
    when "o"
      Subsequent::Commands::OpenLinks.call(state)
    when "a"
      archive_card(state)
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
      Subsequent::TrelloClient.update_checklist_item(checklist_item, pos:)
      fetch_data(sort:)
    when "l"
      pos = card.checklists.last.pos + 1
      Subsequent::TrelloClient.update_checklist(checklist, pos:)
      fetch_data(sort:)
    when "c"
      pos = cards.last.pos + 1
      Subsequent::TrelloClient.update_card(card, pos:)
      fetch_data(sort:)
    else
      state
    end
  end

  def self.sort(state)
    state => { cards: }

    char = input.getch

    case char
    when "f"
      Subsequent::State.format(cards:, sort: Subsequent::Sort::First)
    when "m"
      sort = Subsequent::Sort::MostUncheckedItems
      Subsequent::State.format(cards:, sort:)
    when "l"
      sort = Subsequent::Sort::LeastUncheckedItems
      Subsequent::State.format(cards:, sort:)
    when "q", "\u0004", "\u0003"
      Subsequent::State.new(**state.to_h, mode: :normal)
    else
      state
    end
  end

  def self.archive_card(state)
    state => { card:, sort: }

    output.print("#{red("Archive this card?")} (y/n) ")
    char = input.getch

    if char == "y"
      Subsequent::TrelloClient.update_card(card, closed: true)
      fetch_data(sort:)
    else
      state
    end
  end
end
