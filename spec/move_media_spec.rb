# frozen_string_literal: true

require_relative '../lib/move_media'

# Monkey patch class
class MoveMedia
  attr_accessor :seq
end

RSpec.describe(MoveMedia) do # rubocop:disable Metrics/BlockLength
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
    expect(mm.scan_for_next_seq(destination_video)).to eq(42)
  end

  it 'makes next video name' do
    mm = MoveMedia.new
    mm.scan_for_next_seq(destination_video)
    expect(mm.make_video_name).to eq('sony_2022-08-22_0000042')

    mm.seq = 666
    expect(mm.make_video_name).to eq('sony_2022-08-22_0000666')
  end

  it 'processes a video' do
    mm = MoveMedia.new
    old_name = "#{source}/PRIVATE/M4ROOT/CLIP/C0001.MP4"
    new_name = mm.process_video(old_name)
    expect(old_name.exist?).to be_false
    expect(new_name.exist?).to be_true
  end

  after(:all) do
    %x(
      git restore --source=HEAD --staged --worktree -- spec/fixtures
      git clean -f spec/fixtures
    )
  end
end
