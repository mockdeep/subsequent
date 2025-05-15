# frozen_string_literal: true

RSpec.describe Subsequent::Configuration do
  describe ".parse" do
    it "sets debug to true when --debug is passed" do
      described_class.parse(["--debug"])

      expect(described_class.debug?).to be(true)
    end

    it "raises an error for unknown arguments" do
      expect { described_class.parse(["--unknown"]) }
        .to raise_error(ArgumentError, "Unknown argument: --unknown")
    end
  end
end
