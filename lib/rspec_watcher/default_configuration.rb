# frozen_string_literal: true

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
