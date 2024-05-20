# frozen_string_literal: true

# module to encapsulate spinner logic
module Subsequent::Actions::Spin
  extend Subsequent::Configuration::Helpers

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

  # display a spinner while asynchronously running a block
  # if the DEBUG environment variable is set, the block is run synchronously
  def self.call(&)
    return yield if ENV["DEBUG"]

    thread = Thread.new(&)

    while thread.alive?
      output.clear_screen
      output.print(SPINNER.next)
      sleep(0.1)
    end
    output.clear_screen

    thread.value
  end
end
