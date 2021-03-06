# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/app/boot')

use Rack::CanonicalHost, ENV['DOMAIN'] if ENV['DOMAIN']

run Rack::URLMap.new({
  '/' => Brt::App,
  '/news' => Brt::NewsApp,
  '/team' => Brt::Team,
  '/rennen' => Brt::Events,
  '/kontakt' => Brt::Contact,
})
