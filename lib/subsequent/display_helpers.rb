# frozen_string_literal: true

module Subsequent::DisplayHelpers
  def gray(string)
    "\e[94m#{string}\e[0m"
  end

  def cyan(string)
    "\e[36m#{string}\e[0m"
  end

  def green(string)
    "\e[32m#{string}\e[0m"
  end

  def red(string)
    "\e[31m#{string}\e[0m"
  end

  def yellow(string)
    "\e[33m#{string}\e[0m"
  end

  def link(url)
    "\e]8;;#{url}\e\\link\e]8;;\e\\"
  end

  def linkify(string)
    string
      .split
      .map { |word| word.start_with?("http") ? "(#{link(word)})" : word }
      .join(" ")
  end
end
