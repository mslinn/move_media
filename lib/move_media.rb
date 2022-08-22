# frozen_string_literal: true

# Monkey patch the String class
class String
  def present?
    !strip.empty?
  end

  def integer?
    to_i.to_s == self
  end
end

# @param drive [String] contains the mount path to be verified.
def drive_mounted?(drive)
  %x(mount | grep #{drive}).present?
end

# Moves Sony camera thumbnails for video_filename from source to destination
def move_thumbnails(source, destination, video_filename)
  sony_thumbnails(source, video_filename).each do |old_path|
    old_name = File.basename(x, '.*')
    new_path = "#{destination}/#{old_name}.jpg"
    move_and_rename(old_path, new_path)
  end
end

def move_and_rename(old_path, new_path)
  File.rename old_path, new_path
end

def scan_for_highest_seq(destination)
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

# [ /mnt/h/PRIVATE/M4ROOT/THMBNL/C0001T01.JPG ]
# @return [[String]] JPG filenames on memory card
def sony_thumbnails(source, stem)
  thumb_source_names = "#{source}/PRIVATE/M4ROOT/THMBNL/#{stem}*.JPG"
  Dir[thumb_source_names]
end

def source_bash(dos_drive)
  match_data = dos_drive.match(/^([a-zA-Z]):/)
  raise "#{dos_drive}  is an invalid DOS drive specification." unless match_data && match_data.length == 2

  "/mnt/#{match_data[1].downcase}"
end

# /mnt/h/PRIVATE/M4ROOT/CLIP/C0001.MP4
def video_filenames(source)
  Dir["#{source}/**/*.MP4"].sort
end

def main
  topic = 'sony'
  source = '/mnt/h'
  drive = 'h:'
  destination = '/mnt/e/media/staging'

  %x(sudo mount -t drvfs #{drive} #{source})

  seq = scan_for_highest_seq destination

  # Destination files are yyyy-mm-dd_topic_01234.{mp4,jpg}
  video_filenames(source).each do |fn|
    filename = File.basename(fn, '.*')

    new_name = "#{topic}_#{Date.today}_#{seq}"
    move_and_rename fn, "#{destination}/#{new_name}.mp4"

    move_thumbnails(source, destination, video_filenameq)

    seq += 1
  end

  %x(sudo umount #{source})
end
