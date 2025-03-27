# frozen_string_literal: true

RSpecWatcher.configure do
  watch 'spec', only: /_spec\.rb\z/ do |modified, added, _removed|
    modified + added
  end

  watch 'spec', ignore: /_spec\.rb\z|examples.txt\z/

  watch 'app', only: /\.rb\z/, ignore: %r{controllers/} do |modified, added, removed|
    (modified + added + removed).map do |path|
      file_path = Pathname.new(path).relative_path_from(Rails.root.join('app'))
      spec_path = file_path.sub(/.rb\z/, '_spec.rb')
      Rails.root.join('spec', spec_path).to_s
    end
  end

  watch 'app/controllers', only: /\.rb\z/ do |modified, added, removed|
    (modified + added + removed).map do |path|
      file_path = Pathname.new(path).relative_path_from(Rails.root.join('app', 'controllers'))
      spec_path = file_path.sub(/_controller.rb\z/, '_spec.rb')
      Rails.root.join('spec', 'requests', spec_path).to_s
    end
  end

  watch 'config', only: /routes\.rb\z/
end
