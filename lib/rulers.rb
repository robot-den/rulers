require "rulers/version"
require "rulers/routing"
require "rulers/util"
require "rulers/dependencies"
require "rulers/controller"

module Rulers
  class Application
    def call(env)
      return [404, {'Content-Type' => 'text/html'}, []] if env['PATH_INFO'] == '/favicon.ico'
      return [301, {'Content-Type' => 'text/html', 'Location' => 'http://localhost:3001/quotes/index'}, []] if env['PATH_INFO'] == '/'
      klass, act = get_controller_and_action(env)
      rack_app = klass.action(act)
      rack_app.call(env)      
    end
  end
end
