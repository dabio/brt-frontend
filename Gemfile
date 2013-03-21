source 'https://rubygems.org'

gem 'dm-core'
gem 'dm-aggregates'
gem 'dm-migrations', require: false
gem 'dm-postgres-adapter'
gem 'dm-timestamps'
gem 'dm-validations'
gem 'rack-timeout', require: 'rack/timeout'
gem 'scrypt'
gem 'sinatra', require: 'sinatra/base'
gem 'sinatra-r18n', require: 'sinatra/r18n'
gem 'sinatra-flash-nicer', require: 'sinatra/flash'
gem 'sinatra-redirect-with-flash', require: 'sinatra/redirect_with_flash'
gem 'puma', require: false

group :development do
  gem 'shotgun', require: false
end

group :test do
  gem 'rack-test', require: 'rack/test'
  gem 'simplecov'
end

group :production do
  gem 'newrelic_rpm'
end

