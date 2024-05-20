module Subsequent::Actions::Run

  extend Subsequent::TextFormatting
  extend Subsequent::Configuration::Helpers

  DISPLAY_COUNT = 5
  SPINNER = [
    "▐⠂       ▌",
    "▐⠈       ▌",
    "▐ ⠂      ▌",
    "▐ ⠠      ▌",
    "▐  ⡀     ▌",
    "▐  ⠠     ▌",
    "▐   ⠂    ▌",
    "▐   ⠈    ▌",
    "▐    ⠂   ▌",
    "▐    ⠠   ▌",
    "▐     ⡀  ▌",
    "▐     ⠠  ▌",
    "▐      ⠂ ▌",
    "▐      ⠈ ▌",
    "▐       ⠂▌",
    "▐       ⠠▌",
    "▐       ⡀▌",
    "▐      ⠠ ▌",
    "▐      ⠂ ▌",
    "▐     ⠈  ▌",
    "▐     ⠂  ▌",
    "▐    ⠠   ▌",
    "▐    ⡀   ▌",
    "▐   ⠠    ▌",
    "▐   ⠂    ▌",
    "▐  ⠈     ▌",
    "▐  ⠂     ▌",
    "▐ ⠠      ▌",
    "▐ ⡀      ▌",
    "▐⠠       ▌"
  ].cycle

  def self.call
    fetch_data => { cards:, card:, checklist:, checklist_items:, mode: }

    loop do
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
      output.puts commands(checklist:, checklist_items:, mode:)

      handle_input(cards, card, checklist, checklist_items, mode) =>
        { cards:, card:, checklist:, checklist_items:, mode: }
    end
  end

  def self.commands(checklist:, checklist_items:, mode:)
    if mode == :cycle
      [
        checklist_items && "#{cyan("i")} to move checklist item to the end",
        checklist && "#{cyan("l")} to move checklist to the end",
        "#{cyan("c")} to move card to the end",
        "#{cyan("q")} to cancel",
      ].compact
    else
      item_range = (1..checklist_items.size) if checklist_items
      [
        item_range && "#{cyan(item_range.to_a.join(", "))} to toggle task",
        "#{cyan("r")} to refresh",
        "#{cyan("c")} to cycle",
        "#{cyan("q")} to quit",
      ].compact
    end
  end

  def self.fetch_data
    cards = load_cards
    card = cards.first
    checklist = card.checklists.find(&:unchecked_items?)
    checklist_items =
      checklist && checklist.unchecked_items.first(DISPLAY_COUNT)

    { cards:, card:, checklist:, checklist_items:, mode: :normal }
  end

  def self.load_cards
    if ENV["DEBUG"]
      return Subsequent::TrelloClient.fetch_cards
    end

    thread = Thread.new { Subsequent::TrelloClient.fetch_cards }

    while thread.alive?
      output.clear_screen
      output.print SPINNER.next
      sleep 0.1
    end
    output.clear_screen

    thread.value
  end

  def self.handle_input(cards, card, checklist, checklist_items, mode)
    if mode == :cycle
      return cycle(cards:, card:, checklist:, checklist_items:)
    end

    char = input.getch

    case char
    when "q", "\u0004", "\u0003"
      output.puts yellow("Goodbye!")
      exit
    when "r"
      fetch_data
    when "c"
      { cards:, card:, checklist:, checklist_items:, mode: :cycle }
    else
      task_number = Integer(char)
      raise ArgumentError if task_number < 1 || task_number > checklist_items.size

      item = checklist_items[task_number - 1]

      Subsequent::TrelloClient.toggle_checklist_item(item)

      { cards:, card:, checklist:, checklist_items:, mode: }
    end
  rescue ArgumentError
    retry
  end

  def self.cycle(cards:, card:, checklist:, checklist_items:)
    char = input.getch

    case char
    when "q", "\u0004", "\u0003"
      { card:, checklist:, checklist_items:, mode: :normal }
    when "i"
      checklist_item = checklist_items.first
      pos = checklist.items.last.pos + 1
      Subsequent::TrelloClient.update_checklist_item(checklist_item, pos:)
      fetch_data
    when "l"
      pos = card.checklists.last.pos + 1
      Subsequent::TrelloClient.update_checklist(checklist, pos:)
      fetch_data
    when "c"
      pos = cards.last.pos + 1
      Subsequent::TrelloClient.update_card(card, pos:)
      fetch_data
    else
      { cards:, card:, checklist:, checklist_items:, mode: :cycle }
    end
  end

end
