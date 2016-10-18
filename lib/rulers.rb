require "rulers/version"
require "rulers/routing"
require "rulers/util"
require "rulers/dependencies"
require "rulers/controller"

module Rulers
  class Application
    def call(env)
      return [404, {'Content-Type' => 'text/html'}, []] if env['PATH_INFO'] == '/favicon.ico'
      # if env['PATH_INFO'] == '/'
      #   text = File.read("#{File.dirname(__FILE__)}/views/index.html")
      #   return [200, {'Content-Type' => 'text/html'}, [text]]
      # end
      return [301, {'Content-Type' => 'text/html', 'Location' => 'http://localhost:3001/quotes/a_quote'}, []] if env['PATH_INFO'] == '/'
      klass, act = get_controller_and_action(env)
      controller = klass.new(env)
      # begin
        text = controller.send(act)
        [200, {'Content-Type' => 'text/html'}, [text]]
      # rescue
      #   return [200, {'Content-Type' => 'text/html'}, ['Sorry, something went wrong...']]
      # end
    end
  end
end
