source 'https://rubygems.org'

ruby '2.1.2'

gem 'action_args'
gem 'actionpack-xml_parser'
gem 'actionview-encoded_mail_to'
gem 'active_attr'
gem 'active_model_serializers', github: 'ursm/active_model_serializers', branch: 'rails-4.1'
gem 'bootstrap-sass', '~> 2.3' # TODO 3.x に上げる
gem 'carrierwave'
gem 'carrierwave_backgrounder'
gem 'cells'
gem 'chronic'
gem 'closure-compiler'
gem 'coffee-rails', '~> 4.0.0'
gem 'custom_configuration'
gem 'devise'
gem 'devise-async'
gem 'ember-data-source', '0.14'
gem 'ember-rails'
gem 'enumerize', github: 'ursm/enumerize', branch: 'fix-ar4'
gem 'escape_utils'
gem 'event_tracker'
gem 'figaro'
gem 'fog'
gem 'font-awesome-rails'
gem 'gcm'
gem 'gemoji'
gem 'girl_friday'
gem 'github-linguist', group: 'has-icu'
gem 'github-markdown'
gem 'grocer'
gem 'haml-rails'
gem 'hamlbars'
gem 'hashie'
gem 'hiredis'
gem 'hpricot'
gem 'html-pipeline', require: 'html/pipeline', github: 'jch/html-pipeline'
gem 'jquery-atwho-rails', '0.4.7' # 0.4.9 は補完が妙高さんになる
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'mini_magick'
gem 'momentjs-rails'
gem 'oj'
gem 'omniauth'
gem 'omniauth-github'
gem 'party_foul', github: 'tricknotes/party_foul', branch: 'fix-issue-labels-format' # Workaround until this PR is merged: https://github.com/dockyard/party_foul/pull/103
gem 'pg'
gem 'pusher'
gem 'rails', '~> 4.1.0'
gem 'redcarpet'
gem 'redis', require: %w(redis redis/connection/hiredis)
gem 'redis-objects', require: 'redis/objects'
gem 'retriable'
gem 'rinku'
gem 'sanitize'
gem 'sass-rails', '~> 4.0.0'
gem 'sidekiq'
gem 'sinatra', require: false # Sidekiq::Web, GirlFriday::Server
gem 'skylight'
gem 'uglifier', '>= 1.3.0'
gem 'underscore-rails'
gem 'unf'
gem 'unicorn'
gem 'visibilityjs'

group :development do
  gem 'bullet'
  gem 'letter_opener'
  gem 'pry', group: 'test'
  gem 'quiet_assets'
  gem 'tapp-awesome_print', group: 'test'
  gem 'vendorer'
  gem 'what_methods'
end

group :test do
  gem 'capybara', github: 'jnicklas/capybara'
  gem 'capybara-webkit'
  gem 'database_rewinder'
  gem 'email_spec', github: 'bmabey/email-spec'
  gem 'factory_girl_rails', group: 'development'
  gem 'fakeredis', require: 'fakeredis/rspec', github: 'guilleiguaran/fakeredis'
  gem 'fuubar', '~> 2.0.0.beta'
  gem 'launchy'
  gem 'rspec-cells'
  gem 'rspec-its'
  gem 'rspec-rails', '~> 3.0.0.beta', group: 'development'
  gem 'rspec-retry' # TravisCI上でどうしてもタイミング依存でfailするcapybara経由のexampleがあるので止むなし
  gem 'teaspoon', group: 'development'
end

group :production do
  gem 'dalli'
  gem 'newrelic-redis'
  gem 'newrelic_rpm'
  gem 'rails_12factor', require: false
  gem 'memcachier', require: false
end
