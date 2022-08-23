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
def mount_memory_card(drive, source)
  return true if drive_mounted?(source)

  %x(sudo mkdir #{source}) unless File.exist?(source)
  %x(sudo mount -t drvfs #{drive} #{source})
  false
end

# @param dos_drive [String] has format X:
# @return Linux mount point for DOS drive under /mnt, for example /mnt/x
def mount_point(dos_drive)
  match_data = dos_drive.match(/^([a-zA-Z]):/)
  raise "#{dos_drive}  is an invalid DOS drive specification." unless match_data && match_data.length == 2

  "/mnt/#{match_data[1].downcase}"
end

def move_and_rename(old_path, new_path)
  File.rename(old_path, new_path)
end

# @return [[String]] JPG filenames on memory card
#   example: [ /mnt/h/PRIVATE/M4ROOT/THMBNL/C0001T01.JPG ]
def sony_thumbnail(source, stem)
  thumb_source_names = "#{source}/PRIVATE/M4ROOT/THMBNL/#{stem}*.JPG"
  Dir[thumb_source_names]
end

def unmount_memory_card(source)
  %x(sudo umount #{source})
end

# /mnt/h/PRIVATE/M4ROOT/CLIP/C0001.MP4
def video_filenames(source)
  Dir["#{source}/**/*.MP4"].sort
end
