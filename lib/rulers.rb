require "rulers/version"

module Rulers
  class Application
    def call(env)
      `echo debug > debug.log`
      [200, {'Content-Type' => 'text/html'}, ["Hello world!! It's rulers!"]]
    end
  end
end
