# frozen_string_literal: true

RSpec.describe Subsequent::Actions::Spin do
  it "displays a spinner while running a block" do
    allow(output).to receive(:clear_screen).twice

    described_class.call { 5 }

    expect(output.string).to eq("▐⠂       ▌")
  end

  it "returns the value of the block" do
    result = described_class.call { 5 }

    expect(result).to eq(5)
  end

  it "runs the block synchronously if DEBUG is set" do
    ENV["DEBUG"] = "true"
    result = described_class.call { 5 }

    expect(result).to eq(5)
  ensure
    ENV.delete("DEBUG")
  end
end
