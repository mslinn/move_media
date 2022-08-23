# frozen_string_literal: true

require_relative 'lib/move_media/version'

# rubocop:disable Metrics/BlockLength
Gem::Specification.new do |spec|
  github = 'https://github.com/mslinn/move_media'

  spec.authors = ['Mike Slinn']
  spec.description = <<~END_OF_DESC
    Moves files from Sony Camera memory cards to permanent storage.
  END_OF_DESC
  spec.bindir = 'exe'
  spec.email = ['mslinn@mslinn.com']
  spec.files = Dir['.rubocop.yml', 'LICENSE.*', 'Rakefile', '{lib,spec}/**/*', '*.gemspec', '*.md']
  spec.executables = 'move_media'
  spec.homepage = 'https://www.mslinn.com/av_studio/210-sony-a7iii.html'
  spec.license = 'MIT'
  spec.metadata = {
    'allowed_push_host' => 'https://rubygems.org',
    'bug_tracker_uri'   => "#{github}/issues",
    'changelog_uri'     => "#{github}/CHANGELOG.md",
    'homepage_uri'      => spec.homepage,
    'source_code_uri'   => github,
  }
  spec.name = 'move_media'
  spec.post_install_message = <<~END_MESSAGE

    Thanks for installing #{spec.name}!

  END_MESSAGE
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.6.0'
  spec.summary = 'Moves files from Sony Camera memory cards to permanent storage.'
  spec.test_files = spec.files.grep(%r!^(test|spec|features)/!)
  spec.version = MoveMediaVersion::VERSION
end
# rubocop:enable Metrics/BlockLength
