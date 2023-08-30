# frozen_string_literal: true

namespace :rspec_watcher do
  desc 'Start the watcher with configuration from config/rspec_watcher.rb'
  task :watch do
    abort('Not running in test environment') unless Rails.env.test?

    require 'rspec/core'

    config_path = Rails.root.join('config/rspec_watcher').to_s
    if File.exist?(config_path)
      require config_path
    else
      require_relative '../default_configuration'
    end

    RSpecWatcher.start

    puts 'Watching specs...'
    sleep
  end
end
