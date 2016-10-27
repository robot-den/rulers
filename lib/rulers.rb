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
      controller = klass.new(env)
      controller.send(act)
      if controller.get_response
        st, hd, rs = controller.get_response.to_a
        hd['Content-Type'] = 'text/html'
        [st, hd, [rs.body].flatten]
      else
        text = controller.send(:render, act.to_sym)
        [200, {'Content-Type' => 'text/html'}, [text]]
      end
    end
  end
end
