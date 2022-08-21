# frozen_string_literal: true

require_relative "../lib/move_media"

RSpec.describe(MoveMediaVersion) do
  include MoveMediaVersion

  let(:config) { instance_double("Configuration") }

  it "returns the usual Ruby value" do
    array = [1, 2, 3, 4, 5]
    expect(move_media(array, -1)).to eq(5)
    expect(move_media([], 1)).to raise_exception
  end

end
