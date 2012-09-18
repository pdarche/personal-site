require './app'
run Sinatra::Application
use Rack::Static, :urls => ['/css'], :root => 'public'
