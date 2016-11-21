require "rulers/version"
require "rulers/routing"
require "rulers/util"
require "rulers/dependencies"
require "rulers/controller"

module Rulers
  class Application
    def call(env)
      return [404, {'Content-Type' => 'text/html'}, []] if env['PATH_INFO'] == '/favicon.ico'
      # return [301, {'Content-Type' => 'text/html', 'Location' => 'http://localhost:3001/quotes/index'}, []] if env['PATH_INFO'] == '/'
      klass, act = get_controller_and_action(env)
      rack_app = klass.action(act)
      rack_app.call(env)
    end

    def get_controller_and_action(env)
      _, controller, action, after = env['PATH_INFO'].split('/', 4)
      controller = controller.capitalize + 'Controller'
      [Object.const_get(controller), action]
    end

    def route(&block)
      @route_obj ||= RouterObject.new
      @route_obj.instance_eval(&block)
    end

    def get_rack_app(env)
      raise 'No routes!' unless @route_obj
      @route_obj.check_url env['PATH_INFO']
    end
  end
end
