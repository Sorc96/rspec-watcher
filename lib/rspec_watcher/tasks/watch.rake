# frozen_string_literal: true

namespace :rspec_watcher do
  desc 'Start the watcher'
  task :watch do
    ENV['RSPEC_WATCHER'] = 'true'

    if defined?(Rails)
      abort('Not running in test environment') unless Rails.env.test?

      Rake::Task['environment'].invoke
    end

    if RSpecWatcher.rules.empty?
      require_relative '../default_configuration'
      puts 'Using default configuration'
    end

    RSpecWatcher.start

    puts 'Watching specs...'
    sleep
  end
end
