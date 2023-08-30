# frozen_string_literal: true

namespace :rspec_watcher do
  desc 'Start the watcher with configuration from config/rspec_watcher.rb'
  task :watch do
    abort('Not running in test environment') unless Rails.env.test?

    require 'rspec/core'
    require Rails.root.join('config/rspec_watcher')

    RSpecWatcher.start

    puts 'Watching specs...'
    sleep
  end
end
