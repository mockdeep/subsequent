# frozen_string_literal: true

RSpec.describe Subsequent::DisplayHelpers do
  include described_class

  describe "#gray" do
    it "wraps string in gray ANSI code" do
      expect(gray("text")).to eq("\e[94mtext\e[0m")
    end
  end

  describe "#cyan" do
    it "wraps string in cyan ANSI code" do
      expect(cyan("text")).to eq("\e[36mtext\e[0m")
    end
  end

  describe "#green" do
    it "wraps string in green ANSI code" do
      expect(green("text")).to eq("\e[32mtext\e[0m")
    end
  end

  describe "#red" do
    it "wraps string in red ANSI code" do
      expect(red("text")).to eq("\e[31mtext\e[0m")
    end
  end

  describe "#yellow" do
    it "wraps string in yellow ANSI code" do
      expect(yellow("text")).to eq("\e[33mtext\e[0m")
    end
  end

  describe "#link" do
    it "wraps URL in terminal hyperlink escape codes" do
      expect(link("http://example.com"))
        .to eq("\e]8;;http://example.com\e\\link\e]8;;\e\\")
    end
  end

  describe "#linkify" do
    it "returns a string with links" do
      string = "http://example.com is a great website"

      expect(linkify(string))
        .to eq("(#{link("http://example.com")}) is a great website")
    end

    it "returns string unchanged when there are no URLs" do
      expect(linkify("no links here")).to eq("no links here")
    end

    it "linkifies multiple URLs" do
      string = "visit http://a.com and http://b.com today"

      expect(linkify(string))
        .to eq("visit (#{link("http://a.com")}) and (#{link("http://b.com")}) today")
    end

    it "linkifies a URL at the end of a string" do
      string = "check out http://example.com"

      expect(linkify(string)).to eq("check out (#{link("http://example.com")})")
    end
  end
end
