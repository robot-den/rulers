require 'erubis'
require "rulers/file_model"
require "rulers/sqlite_model"

module Rulers
  class Controller
    include Rulers::Model

    def initialize(env)
      @env = env
      @routing_params = {}
    end

    def env
      @env
    end

    def request
      @request ||= Rack::Request.new(@env)
    end

    def params
      request.params.merge @routing_params
    end

    def render(view_name, locals = {})
      filename = File.join 'app', 'views', "#{controller_name}","#{view_name}.html.erb"
      template = File.read filename
      eruby = Erubis::Eruby.new template
      pass_controller_instance_variables_to eruby
      eruby.result locals
    end

    def response(text, status = 200, headers = {})
      raise 'Already responded' if @response
      @response = Rack::Response.new([text].flatten, status, headers)
    end

    def get_response
      @response
    end

    def render_response(*args)
      response(render(*args))
    end

    def dispatch(action, routing_params = {})
      @routing_params = routing_params
      self.send(action)
      if get_response
        st, hd, rs = get_response.to_a
        hd['Content-Type'] = 'text/html'
        [st, hd, [rs.body].flatten]
      else
        text = self.send(:render, act.to_sym)
        [200, {'Content-Type' => 'text/html'}, [text]]
      end
    end

    def self.action(act, rp = {})
      proc { |e| self.new(e).dispatch(act, rp) }
    end

    private

    def controller_name
      Rulers.to_underscore self.class.to_s.gsub /Controller$/, ''
    end

    def pass_controller_instance_variables_to eruby
      if instance_variables
        instance_variables.each {|var| eruby.instance_variable_set var, instance_variable_get(var) }
      end
    end
  end
end
