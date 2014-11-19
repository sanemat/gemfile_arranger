source 'https://rubygems.org'
# For heroku
ruby '2.1.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', github: 'rails/rails', branch: '4-1-stable'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '< 5.0.0'
gem 'sprockets'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

gem 'angularjs-rails'
gem 'font-awesome-rails'
gem 'haml-rails'
gem 'newrelic_rpm'
gem 'octokit'
gem 'faraday-http-cache'
gem 'omniauth-github'
gem 'que'
gem 'sentry-raven'
gem 'multi_json'
gem 'oj'

gem 'bourbon'
gem 'neat'
gem 'normalize-rails'

gem 'docker-api', require: 'docker'

gem 'base32'
gem 'safe_yaml'
gem 'druuid'

group :staging, :production do
  gem 'rails_12factor'
  gem 'unicorn'
end

group :development, :test do
  gem 'byebug'
  gem 'pry'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'dotenv-rails'
end

group :test do
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'database_rewinder'
  gem 'factory_girl_rails'
  gem 'launchy'
  gem 'webmock'
  gem 'shoulda-matchers'
  gem 'timecop'
  gem 'nokogiri'
end

group :development do
  gem 'spring'
  gem 'railroady'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

