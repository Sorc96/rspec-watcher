# frozen_string_literal: true

require_relative 'rspec_watcher/version'
require_relative 'rspec_watcher/railtie' if defined?(Rails)

module RSpecWatcher
  SPEC_INFERRER = ->(_modified, _added, _removed) { [] }
  PATH_INFERRER = ->(path) { Rails.root.join(path) }
  RELOADER = -> { Rails.application.reloader.reload! }

  @path_inferrer = PATH_INFERRER
  @reloader = RELOADER
  @rules = []

  class << self
    attr_accessor :path_inferrer, :reloader
    attr_reader :rules

    def configure(&block)
      @rules = []
      @failed_specs = []
      instance_exec(&block)
    end

    def watch(path, **options, &inferrer)
      inferrer ||= SPEC_INFERRER
      rules << [path, options, inferrer]
    end

    def start
      listeners.each(&:start)
    end

    private

    def listeners
      rules.map do |path, options, inferrer|
        Listen.to(path_inferrer.call(path), **options) do |modified, added, removed|
          run_specs(inferrer.call(modified, added, removed))
        end
      end
    end

    def run_specs(paths)
      clear_screen
      reloader.call
      RSpec.clear_examples
      RSpec.world.wants_to_quit = false
      RSpec::Core::Runner.run(specs_to_run(paths))
      prepare_failed_specs_for_rerun
    end

    def clear_screen
      puts "\e[H\e[2J"
    end

    # Filter out nonexistent files and paths to specific lines if the whole file will be rerun
    def specs_to_run(paths)
      (paths + @failed_specs).reject do |path|
        file_path = path.split(':').first
        next true unless File.exist?(file_path)

        path.include?(':') && paths.include?(file_path)
      end
    end

    def prepare_failed_specs_for_rerun
      @failed_specs = RSpec
        .world
        .all_examples
        .select(&:exception)
        .map(&:location_rerun_argument)
        .map { |path| File.absolute_path(path) }
    end
  end
end
