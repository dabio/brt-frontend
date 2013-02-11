# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/app/boot')

run Rack::URLMap.new({
  '/' => ModuleName::App,
})
