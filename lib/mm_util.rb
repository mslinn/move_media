# frozen_string_literal: true

require 'fileutils'
require 'yaml'

# Monkey patch the String class
class String
  def present?
    !strip.empty?
  end

  def integer?
    !!match(/^(\d)+$/)
  end
end

def delete_mp4s(source)
  Dir[source]
end

# @param mount_path [String] contains the mount path to be verified.
def drive_mounted?(mount_path)
  %x(mount | grep #{mount_path}).present?
end

# @return [Boolean] true if memory card was already mounted
def mount_memory_card(drive)
  drive_path = mount_point(drive)
  return true if drive_mounted?(drive_path)

  %x(sudo mkdir #{drive_path}) unless File.exist?(drive_path)
  %x(sudo mount -t drvfs #{drive.upcase} #{drive_path})
  false
end

# @param dos_drive [String] has format X:
# @return Linux mount point for DOS drive under /mnt, for example /mnt/x
def mount_point(dos_drive)
  match_data = dos_drive.match(/^([a-zA-Z]):/)
  raise "#{dos_drive}  is an invalid DOS drive specification." unless match_data && match_data.length == 2

  "/mnt/#{match_data[1].downcase}"
end

# @param old_path [String] file to be moved; raises exception if not present
def move_and_rename(old_path, new_path)
  FileUtils.cp(old_path, new_path)
  File.delete(old_path)
end

# @param source [String] Directory containing videos.
# @param stem [String] File name of video, without extension
# @return [[String]] JPG filenames on memory card
#   example: [ /mnt/h/PRIVATE/M4ROOT/THMBNL/C0001T01.JPG ]
def sony_thumbnail(source, stem)
  thumb_source_names = "#{source}/PRIVATE/M4ROOT/THMBNL/#{stem}*.JPG"
  Dir[thumb_source_names][0]
end

def unmount_memory_card(mount_point)
  %x(sudo umount #{mount_point})
end

# /mnt/h/PRIVATE/M4ROOT/CLIP/C0001.MP4
def video_filenames(source)
  Dir["#{source}/**/*.MP4"].sort
end
