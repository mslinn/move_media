# frozen_string_literal: true

require_relative '../lib/move_media'

RSpec.describe(MoveMediaVersion) do
  include MoveMediaVersion

  # let(:config) { instance_double('Configuration') }
  let(:source) { 'spec/fixtures' }

  it 'verifies mount point' do
    drive = 'h:'
    expect(mount_point(drive)).to eq('/mnt/h')

    drive = 'H:'
    expect(mount_point(drive)).to eq('/mnt/h')
  end

  it 'finds thumbnails for video file stem C0001' do
    expect(sony_thumbnails(source, 'C0001').length).to eq(4)
  end

  it 'finds videos' do
    expect(video_filenames(source).length).to eq(1)
  end
end
