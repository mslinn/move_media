# frozen_string_literal: true

require_relative '../lib/move_media'

RSpec.configure do |config|
  config.filter_run :focus
  config.order = 'defined'
  config.run_all_when_everything_filtered = true

  # See https://relishapp.com/rspec/rspec-core/docs/command-line/only-failures
  config.example_status_persistence_file_path = 'spec/status_persistence.txt'
end
