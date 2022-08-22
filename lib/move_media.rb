# frozen_string_literal: true

CONFIGURATION_FILE = "#{Dir.home}/.move_media"

require_relative 'mm_util'

# Moves media from a Sony memory card to permanent storage
class MoveMedia
  attr_reader :destination, :drive, :topic

  def initialize
    @destination = Dir.home
    @drive = 'c:'
    @topic = 'sony'
  end

  # Move Sony camera thumbnails for video_filename from source to destination
  def move_thumbnails(source, destination, video_filename)
    sony_thumbnails(source, video_filename).each do |old_path|
      old_name = File.basename(x, '.*')
      new_path = "#{destination}/#{old_name}.jpg"
      move_and_rename(old_path, new_path)
    end
  end

  # Scans video file names in destination
  # Files are named like: sony_2022-08-22_000001.mp4
  # @return [int] next sequence number based on what is already present in destination
  def scan_for_next_seq(destination)
    seq = 0
    Dir[destination].each do |path|
      basename = File.basename(path, '.*')
      segment = if basename.include?('_')
                  basename.split('_')[-1]
                elsif basename.include?('-')
                  basename.split('-')[-1]
                else
                  seq
                end
      seq = [seq, segment.to_i].max if segment.integer?
    end
    seq + 1
  end

  def read_configuration
    raise "Error: #{CONFIGURATION_FILE} does not exist." unless File.exist? CONFIGURATION_FILE

    config = YAML.load_file(CONFIGURATION_FILE)
    @destination = config['destination']
    @drive = config['drive']
    @topic = config['topic']
  end

  def main
    topic = 'sony'
    drive = 'h:'
    source = mount_point(drive)
    already_mounted = mount_memory_card(source, drive)
    destination = '/mnt/e/media/staging'

    seq = scan_for_highest_seq destination

    # Destination files are yyyy-mm-dd_topic_01234.{mp4,jpg}
    video_filenames(source).each do |fn|
      filename = File.basename(fn, '.*')

      new_name = "#{topic}_#{Date.today}_#{seq}"
      move_and_rename fn, "#{destination}/#{new_name}.mp4"

      move_thumbnails(source, destination, video_filenameq)

      seq += 1
    end

    unmount_memory_card(source) unless already_mounted
  end
end
