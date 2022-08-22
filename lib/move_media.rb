# frozen_string_literal: true

CONFIGURATION_FILE = "#{Dir.home}/.move_media"

require 'date'
require_relative 'mm_util'

# Moves media from a Sony memory card to permanent storage
class MoveMedia
  attr_reader :destination, :drive, :topic

  SIGNIFICANT_DIGITS = 7

  def initialize
    read_configuration
    @seq = 1
  end

  # Move Sony camera thumbnails for video_filename from source to destination
  def move_thumbnails(source, destination, video_filename)
    sony_thumbnails(source, video_filename).each do |old_path|
      old_name = File.basename(x, '.*')
      new_path = "#{destination}/#{old_name}.jpg"
      move_and_rename(old_path, new_path)
    end
  end

  def make_video_name
    seq = @seq.to_s.rjust(SIGNIFICANT_DIGITS, '0')
    "#{@topic}_#{Date.today}_#{seq}"
  end

  # Destination files are yyyy-mm-dd_topic_0001234.{mp4,jpg}
  def process_video(fn_fq)
    new_name = make_video_name
    move_and_rename(fn_fq, "#{@destination}/#{new_name}.mp4")
    @seq += 1
    new_name
  end

  # Scans video file names in destination
  # Files are ideally named like: sony_2022-08-22_000001.mp4
  # @return [int] next sequence number based on what is already present in destination
  def scan_for_next_seq(destination)
    files = Dir["#{destination}/#{topic}_*"]
    @seq = files.length
    files.each do |path|
      basename = File.basename(path, '.*')
      seq = basename.split('_')[-1]
      @seq = [@seq, seq.to_i].max if seq.integer?
    end
    @seq += 1
  end

  def read_configuration
    raise "Error: #{CONFIGURATION_FILE} does not exist." unless File.exist? CONFIGURATION_FILE

    config = YAML.load_file(CONFIGURATION_FILE)
    @destination = config['destination']
    @drive = config['drive']
    @source = mount_point(@drive)
    @topic = config['topic']
  end

  # Leaves memory card mounted if it was already mounted
  def main
    source = mount_point(@drive)
    already_mounted = mount_memory_card(source, drive)
    scan_for_next_seq(destination)
    video_filenames(source).each do |fn|
      new_name = process_video(fn)
      move_thumbnails(source, @destination, new_name)
    end
    unmount_memory_card(source) unless already_mounted
  end
end
