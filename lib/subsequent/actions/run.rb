module Subsequent::Actions::Run

  extend Subsequent::TextFormatting

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
      $stdout.clear_screen
      puts "#{card.name} (#{link(card.short_url)})"
      puts "=" * card.name.size
      if checklist
        checklist_items.each_with_index do |item, index|
          icon = item.checked? ? "✔" : "☐"
          item_name = linkify(item.name)
          name = item.checked? ? gray(item_name) : green(item_name)
          puts "#{index + 1}. #{icon} #{name}"
        end
      else
        puts "No unchecked items, finish the card!"
      end

      puts
      puts commands(checklist_items)

      handle_input(card, checklist, checklist_items) => { card:, checklist:, checklist_items: }
    end
  end

  def self.commands(checklist_items)
    item_range = (1..checklist_items.size) if checklist_items
    [
      item_range && "#{cyan(item_range)} to toggle task",
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
      $stdout.clear_screen
      print SPINNER.next
      sleep 0.1
    end
    $stdout.clear_screen

    thread.value
  end

  def self.handle_input(card, checklist, checklist_items)
    input = $stdin.getch

    if input == "q" || input == "\u0004" || input == "\u0003"
      puts yellow("Goodbye!")
      exit
    elsif input == "r"
      fetch_data
    else
      task_number = Integer(input)
      raise ArgumentError if task_number < 1 || task_number > checklist_items.size

      item = checklist_items[input.to_i - 1]

      Subsequent::TrelloClient.toggle_checklist_item(item)

      { card:, checklist:, checklist_items: }
    end
  rescue ArgumentError
    retry
  end

end
