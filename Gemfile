source 'https://rubygems.org'
ruby '2.3.1'

gem 'dm-core'
gem 'dm-aggregates'
gem 'dm-postgres-adapter'
gem 'dm-timestamps'
gem 'dm-validations'
gem 'rack-canonical-host'
# gem 'rack-timeout', require: 'rack/timeout'
gem 'rake'
gem 'redcarpet'
gem 'sendgrid-ruby'
gem 'sinatra', require: 'sinatra/base'
gem 'sinatra-r18n', require: 'sinatra/r18n'
gem 'puma', require: false

group :development do
  gem 'foreman', require: false
  gem 'shotgun', require: false
  gem 'rb-fsevent', require: false
  gem 'sass', require: false
end

group :test do
  gem 'rack-test', require: 'rack/test'
  gem 'simplecov'
end

group :production do
  gem 'newrelic_rpm'
end
