# frozen_string_literal: true

# module to encapsulate display helper methods
module Subsequent::DisplayHelpers
  # return string wrapped in gray color code
  def gray(string)
    "\e[94m#{string}\e[0m"
  end

  # return string wrapped in cyan color code
  def cyan(string)
    "\e[36m#{string}\e[0m"
  end

  # return string wrapped in green color code
  def green(string)
    "\e[32m#{string}\e[0m"
  end

  # return string wrapped in red color code
  def red(string)
    "\e[31m#{string}\e[0m"
  end

  # return string wrapped in yellow color code
  def yellow(string)
    "\e[33m#{string}\e[0m"
  end

  # return link string with url wrapped in terminal escape codes
  def link(url)
    "\e]8;;#{url}\e\\link\e]8;;\e\\"
  end

  # return string with links wrapped in terminal escape codes
  def linkify(string)
    string
      .split
      .map { |word| word.start_with?("http") ? "(#{link(word)})" : word }
      .join(" ")
  end

  # show spinner while block is running
  def show_spinner(&)
    Subsequent::Actions::Spin.call(&)
  end
end
