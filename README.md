# RspecWatcher

Automatically runs specs in reaction to changes in files. Loads the project once and uses code reloading to get changes instead of starting a new process for every test run.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add rspec-watcher

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install rspec-watcher

## Usage

Example configuration for a Rails project in `config/rspec_watcher.rb`:

```ruby
RSpecWatcher.configure do
  watch 'spec', only: /_spec\.rb\z/ do |modified, added, _removed|
    modified + added
  end

  watch 'spec', ignore: /_spec\.rb\z/

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
```

Start the watcher with `RAILS_ENV=test bundle exec rake rspec_watcher:watch`

In order to use trhe watcher without Rails, `path_inferrer` and `reloader` need to be configured. Check `lib/rspec_watcher.rb`

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Sorc96/rspec-watcher.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
