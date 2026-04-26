# frozen_string_literal: true

RSpec.describe Subsequent::Configuration do
  describe ".input" do
    it "defaults to $stdin" do
      described_class.remove_instance_variable(:@input)

      expect(described_class.input).to eq($stdin)
    ensure
      described_class.input = StringIO.new
    end

    it "can be set via writer" do
      custom = StringIO.new
      described_class.input = custom

      expect(described_class.input).to eq(custom)
    end
  end

  describe ".output" do
    it "defaults to $stdout" do
      described_class.remove_instance_variable(:@output)

      expect(described_class.output).to eq($stdout)
    ensure
      described_class.output = StringIO.new
    end

    it "can be set via writer" do
      custom = StringIO.new
      described_class.output = custom

      expect(described_class.output).to eq(custom)
    end
  end

  describe ".parse" do
    it "sets debug to true when --debug is passed" do
      described_class.parse(["--debug"])

      expect(described_class.debug?).to be(true)
    ensure
      described_class.debug = false
    end

    it "sets list_name when --list is passed" do
      described_class.parse(["--list", "Claude"])

      expect(described_class.list_name).to eq("Claude")
    end

    it "sets tag_name when --tag is passed" do
      described_class.parse(["--tag", "@my-tag"])

      expect(described_class.tag_name).to eq("@my-tag")
    end

    it "clears prior list_name when called again without --list" do
      described_class.parse(["--list", "Claude"])
      described_class.parse([])

      expect(described_class.list_name).to be_nil
    end

    it "clears prior tag_name when called again without --tag" do
      described_class.parse(["--tag", "@my-tag"])
      described_class.parse([])

      expect(described_class.tag_name).to be_nil
    end

    it "raises an error for unknown flags" do
      expect { described_class.parse(["--unknown"]) }
        .to raise_error(ArgumentError, "Unknown argument: --unknown")
    end

    it "raises an error for unexpected positional arguments" do
      expect { described_class.parse(["junk"]) }
        .to raise_error(ArgumentError, "Unknown argument: junk")
    end
  end
end
