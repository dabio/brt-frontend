RACK_ENV = ENV['RACK_ENV'] || 'development'
DATABASE_URL = ENV['DATABASE_URL']

require 'bundler/setup'
Bundler.require(:default, RACK_ENV)

DB = Sequel.connect(DATABASE_URL)
DB.sql_log_level = :debug
