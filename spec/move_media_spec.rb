# frozen_string_literal: true

require_relative '../lib/move_media'

RSpec.describe(MoveMediaVersion) do
  include MoveMediaVersion

  # let(:config) { instance_double('Configuration') }

  it 'finds thumbnails for video file stem C0001' do
    source = 'spec/fixtures'

    expect(sony_thumbnails(source, 'C0001').length).to eq(4)
  end
end
