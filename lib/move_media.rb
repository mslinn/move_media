# frozen_string_literal: true

require 'date'

class String
  def is_integer?
    self.to_i.to_s == self
  end
end

def move_thumbnails(source, destination, video_filename)
  thumb_source_names = "#{source}/PRIVATE/M4ROOT/THMBNL/#{video_filename}*.jpg"
  Dir[ thumb_source_names ].each do |old_path|
    old_name = File.basename(x, ".*")
    new_path = "#{destination}/#{old_name}.jpg"
    move_and_rename(old_path, new_path)
  end
end

def move_and_rename(old_path, new_path)
  File.rename old_path, new_path
end

def scan_for_highest_seq(destination)
  seq = 0
  Dir[ destination ].each do |path|
    basename = File.basename(path, ".*")
    if basename.include? '_'
      segment = basename.split('_')[-1]
    elif basename.include? '-'
      segment = basename.split('-')[-1]
    else
      segment = seq
    end
    seq = [seq, segment.to_i].max if segment.is_integer?
  end
  seq + 1
end

topic = 'sony'
date = Date.today.to_s
source = '/mnt/h'
destination = '/mnt/e/media/staging'

%x( sudo mount -t drvfs h: /mnt/h )

seq = scan_for_highest_seq destination

# /mnt/h/PRIVATE/M4ROOT/CLIP/C0001.MP4
video_filenames = Dir["/mnt/h/**/*.MP4"].sort
# p video_filenames

# /mnt/h/PRIVATE/M4ROOT/THMBNL/C0001T01.JPG
image_filenames = Dir["/mnt/h/**/*.JPG"].sort
# p image_filenames

# Destination files are yyyy-mm-dd_topic_01234.{mp4,jpg}
video_filenames.each do |fn|
  filename = File.basename(fn, ".*")

  new_name = "#{topic}_#{date}_#{seq}"
  move_and_rename fn, "#{destination}/#{new_name}.mp4"

  move_thumbnails(source, destination, video_filenameq)

  seq += 1
end

%x( sudo umount /mnt/h )
