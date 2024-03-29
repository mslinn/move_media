CONFIGURATION_FILE = "#{Dir.home}/.move_media"

require 'bytesize'
require 'date'
require_relative 'mm_util'

# Moves media from a Sony memory card to permanent storage
class MoveMedia
  attr_reader :destination_images, :destination_video, :drive, :topic

  SIGNIFICANT_DIGITS = 7

  def initialize
    read_configuration
    @seq = 1
  end

  def human_file_size(filename)
    ByteSize.new(File.size(filename)).to_s
  end

  def make_name(fn_fq)
    date = File.ctime(fn_fq).to_date
    seq = @seq.to_s.rjust(SIGNIFICANT_DIGITS, '0')
    "#{@topic}_#{date}_#{seq}"
  end

  # Move Sony camera thumbnail for video_filename from source to destination
  # @return new path for thumbnail
  def process_thumbnail(fn_fq)
    video_filename_stem = File.basename(fn_fq, '.*')
    old_path = sony_thumbnail(@source, video_filename_stem)
    return nil if old_path.nil?

    new_thumbnail_name = make_name(fn_fq)
    new_path = "#{@destination_images}/#{new_thumbnail_name}.jpg"
    puts "Moving thumbnail from #{old_path} to #{new_path}"
    move_and_rename(old_path, new_path)
    new_path
  end

  # Destination files are yyyy-mm-dd_topic_0001234.{mp4,jpg}
  def process_video(fn_fq)
    new_name = make_name(fn_fq)
    new_name_fq = "#{@destination_video}/#{new_name}.mp4"

    puts "Moving #{human_file_size(fn_fq)} video from #{fn_fq} to #{new_name_fq}"
    move_and_rename(fn_fq, new_name_fq)
    @seq += 1
    new_name_fq
  end

  def read_configuration
    raise "Error: #{CONFIGURATION_FILE} does not exist." unless File.exist? CONFIGURATION_FILE

    config = YAML.load_file(CONFIGURATION_FILE)
    @destination_images = config['destination_images']
    @destination_video = config['destination_video']
    @drive = config['drive']
    @source = mount_point(@drive)
    @topic = config['topic']
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

  # Leaves memory card mounted if it was already mounted
  def main
    already_mounted = mount_memory_card(@drive)
    scan_for_next_seq(@destination_video)
    video_filenames(@source).each do |fn_fq|
      process_video(fn_fq)
      process_thumbnail(fn_fq)
    end
    delete_xml_files(@source)
    unmount_memory_card(@source) unless already_mounted
  end
end
