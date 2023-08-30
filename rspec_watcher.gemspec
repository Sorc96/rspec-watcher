# frozen_string_literal: true

require_relative "lib/rspec_watcher/version"

Gem::Specification.new do |spec|
  spec.name = "rspec-watcher"
  spec.version = RSpecWatcher::VERSION
  spec.authors = ["Matous Vokal"]
  spec.email = ["matous.vokal@gmail.com"]

  spec.summary = "Instant feedback for awesome TDD experience with RSpec."
  spec.description = "Automatically runs specs in reaction to changes in files. Loads the project once and uses code reloading to get changes instead of starting a new process for every test run."
  spec.homepage = "https://github.com/Sorc96/rspec-watcher"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Sorc96/rspec-watcher"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "rspec", "~> 3.0"
end
