# frozen_string_literal: true

namespace :rspec_watcher do
  desc 'Start the watcher'
  task :watch do
    abort('Not running in test environment') if defined?(Rails) && !Rails.env.test?

    require 'rspec/core'

    ENV['RSPEC_WATCHER'] = 'true'

    if RSpecWatcher.rules.empty?
      require_relative '../default_configuration'
      puts 'Using default configuration'
    end

    RSpecWatcher.start

    puts 'Watching specs...'
    sleep
  end
end
