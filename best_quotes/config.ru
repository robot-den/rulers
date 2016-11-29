require './config/application'
# require './middlewares/canadianizer'
# require './middlewares/benchmarker'
# require 'rack/lobster'

# use Rack::Auth::Basic, 'app' do |_, secret|
#   secret == 'qwerty'
# end
# use Canadianizer, ', simple'
# use Rack::ContentType
# use Benchmarker, 100_00
#
# map '/lobster' do
#   use Rack::ShowExceptions
#   run Rack::Lobster.new
# end

# map '/' do
#   run QuotesController.action(:index)
# end

app = BestQuotes::Application.new

use Rack::ContentType

app.route do
  root '', 'quotes#index'
  match '/subapp', (proc { [200, {}, ['Sub-app']] })

  # default routers

  match ':controller/:id/:action'
  match ':controller/:id', default: { action: :show }
  match ':controller', default: { action: :index }
end

run app
