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
    fns = video_filenames(source)
    expect(fns.length).to eq(1)
    expect(fns[0]).to eq("#{source}/PRIVATE/M4ROOT/CLIP/C0001.MP4")
  end
end
