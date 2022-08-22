# frozen_string_literal: true

require_relative '../lib/move_media'

RSpec.describe(MoveMediaVersion) do # rubocop:disable Metrics/BlockLength
  include MoveMediaVersion

  let(:destination_images) { 'spec/fixtures/destination/images' }
  let(:destination_video) { 'spec/fixtures/destination/videos' }
  let(:source) { 'spec/fixtures/source' }

  it 'reads config file' do
    mm = MoveMedia.new
    mm.read_configuration
    expect(mm.destination).to eq('/mnt/e/media/staging')
    expect(mm.drive.length).to eq(2)
    expect(mm.topic).to eq('sony')
  end

  it 'verifies mount point' do
    drive = 'h:'
    expect(mount_point(drive)).to eq('/mnt/h')

    drive = 'H:'
    expect(mount_point(drive)).to eq('/mnt/h')
  end

  it 'finds videos' do
    fns = video_filenames(source)
    expect(fns.length).to eq(1)
    expect(fns[0]).to eq("#{source}/PRIVATE/M4ROOT/CLIP/C0001.MP4")
  end

  it 'finds thumbnails for video file stem C0001' do
    thumbs = sony_thumbnails(source, 'C0001')
    expect(thumbs.length).to eq(4)
    expect(thumbs[0]).to eq("#{source}/PRIVATE/M4ROOT/THMBNL/C0001T01.JPG")
  end

  it 'scans for next sequence number' do
    mm = MoveMedia.new
    expect(mm.scan_for_next_seq(destination_video)).to eq(2)
  end
end
