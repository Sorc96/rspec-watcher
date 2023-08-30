# frozen_string_literal: true

module RSpecWatcher
  class Railtie < Rails::Railtie
    railtie_name :rspec_watcher

    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
    end
  end
end
