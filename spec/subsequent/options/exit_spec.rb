# frozen_string_literal: true

RSpec.describe Subsequent::Options::Exit do
  describe ".match?" do
    it "returns true when text is q" do
      expect(described_class.match?(make_state, "q")).to be(true)
    end

    it "returns true when text is Ctrl+D" do
      expect(described_class.match?(make_state, "\u0004")).to be(true)
    end

    it "returns true when text is Ctrl+C" do
      expect(described_class.match?(make_state, "\u0003")).to be(true)
    end

    it "returns false when text is something else" do
      expect(described_class.match?(make_state, "x")).to be(false)
    end
  end

  describe ".call" do
    it "exits the program" do
      expect { described_class.call(make_state, "q") }
        .to raise_error(SystemExit)
    end

    it "resets the terminal title" do
      described_class.call(make_state, "q")
    rescue SystemExit
      expect(output.string).to include("\e]0;\a")
    end
  end
end
