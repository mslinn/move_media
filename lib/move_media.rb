# frozen_string_literal: true

CONFIGURATION_FILE = "#{Dir.home}/.move_media"

require_relative 'mm_util'

# Moves media from a Sony memory card to permanent storage
class MoveMedia
  attr_reader :destination, :drive, :topic

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

  # Destination files are yyyy-mm-dd_topic_01234.{mp4,jpg}
  def process_video(source, fn_fq)
    new_name = "#{@topic}_#{Date.today}_#{seq}"
    move_and_rename(fn_fq, "#{@destination}/#{new_name}.mp4")
    move_thumbnails(source, @destination, video_filenameq)
    @seq += 1
  end

  # Scans video file names in destination
  # Files are named like: sony_2022-08-22_000001.mp4
  # @return [int] next sequence number based on what is already present in destination
  def scan_for_next_seq(destination)
    @seq = 0
    Dir[destination].each do |path|
      basename = File.basename(path, '.*')
      segment = if basename.include?('_')
                  basename.split('_')[-1]
                elsif basename.include?('-')
                  basename.split('-')[-1]
                else
                  @seq
                end
      @seq = [@seq, segment.to_i].max if segment.integer?
    end
    @seq + 1
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
    scan_for_highest_seq(destination)
    video_filenames(source).each { |fn| process_video(source, fn) }
    unmount_memory_card(source) unless already_mounted
  end
end
