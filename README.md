# RSpecWatcher

Provides an instant feedback loop for TDD with RSpec. Automatically runs specs in reaction to changes in files. Inspired by [Guard](https://github.com/guard/guard), but unlike Guard, the watcher does not start a new process every time. It only loads the project once and uses code reloading to get changes. Needs to be restarted after changes to files that do not get reloaded (just like you would restart a Rails development server).

Specs that fail are remembered and will be rerun until they pass again. This enables a nearly instant TDD feedbeck loop, because every spec we add will be automatically picked up and run until we add the implementation.

## Installation

Add `rspec-watcher` to the Gemfile, only needs to exist in the `test` group.

```ruby
group :test do
  gem 'rspec-watcher'
end
```

Then run `bundle install`

## Usage

### Configuration

Disable caching classes in `config/environments/test.rb` when the watcher is running:

```ruby
config.cache_classes = ENV['RSPEC_WATCHER'].nil?
```

Rules for the watcher and other options can be customized, for example in a Rails initializer. Not passing a block to a `watch` rule will run all specs. The configuration shown here is used by default:

```ruby
# config/initializers/rspec_watcher.rb

if ENV['RSPEC_WATCHER']
  RSpecWatcher.configure do
    watch 'spec', only: /_spec\.rb\z/ do |modified, added, _removed|
      modified + added
    end

    watch 'spec', ignore: /_spec\.rb\z|examples.txt\z/

    watch 'app', only: /\.rb\z/, ignore: %r{controllers/} do |modified, added, removed|
      (modified + added + removed).map do |path|
        path.sub('app/', 'spec/').sub('.rb', '_spec.rb')
      end
    end

    watch 'app/controllers', only: /\.rb\z/ do |modified, added, removed|
      (modified + added + removed).map do |path|
        path.sub('app/', 'spec/').sub('controllers/', 'requests/').sub('_controller.rb', '_spec.rb')
      end
    end

    watch 'config', only: /routes\.rb\z/
  end
end
```

### Running the watcher

Start the watcher with `RAILS_ENV=test bundle exec rake rspec_watcher:watch`

In order to use the watcher without Rails, `path_inferrer` and `reloader` need to be configured. Check `lib/rspec-watcher.rb`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Sorc96/rspec-watcher.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
