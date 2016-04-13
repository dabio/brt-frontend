require "./environment"

use Rack::Deflater
use Rack::CanonicalHost, ENV['DOMAIN'] if ENV['DOMAIN']

require "./app"
run BRT
