# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/app/boot')

use Rack::Gauges, tracker: '50789ec5f5a1f5156f00006f'

run Rack::URLMap.new({
  '/' => Brt::App,
  '/news' => Brt::NewsApp,
  '/team' => Brt::Team,
  '/rennen' => Brt::Events,
  '/kontakt' => Brt::Contact,
})
