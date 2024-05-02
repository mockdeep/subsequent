module Subsequent::TextFormatting
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

  def self.link(url)
    "\e]8;;#{url}\e\\link\e]8;;\e\\"
  end
end
