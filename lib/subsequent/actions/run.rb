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
    fetch_data => { card:, checklist:, checklist_items: }

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
      output.puts commands(checklist_items)

      handle_input(card, checklist, checklist_items) => { card:, checklist:, checklist_items: }
    end
  end

  def self.commands(checklist_items)
    item_range = (1..checklist_items.size) if checklist_items
    [
      item_range && "#{cyan(item_range.to_a.join(", "))} to toggle task",
      "#{cyan("r")} to refresh",
      "#{cyan("q")} to quit",
    ].compact
  end

  def self.fetch_data
    card = load_card
    checklist = card.checklists.find(&:unchecked_items?)
    checklist_items =
      checklist && checklist.unchecked_items.first(DISPLAY_COUNT)

    { card:, checklist:, checklist_items: }
  end

  def self.load_card
    thread = Thread.new { Subsequent::TrelloClient.fetch_next_card }

    while thread.alive?
      output.clear_screen
      output.print SPINNER.next
      sleep 0.1
    end
    output.clear_screen

    thread.value
  end

  def self.handle_input(card, checklist, checklist_items)
    char = input.getch

    if char == "q" || char == "\u0004" || char == "\u0003"
      output.puts yellow("Goodbye!")
      exit
    elsif char == "r"
      fetch_data
    else
      task_number = Integer(char)
      raise ArgumentError if task_number < 1 || task_number > checklist_items.size

      item = checklist_items[task_number - 1]

      Subsequent::TrelloClient.toggle_checklist_item(item)

      { card:, checklist:, checklist_items: }
    end
  rescue ArgumentError
    retry
  end

end
