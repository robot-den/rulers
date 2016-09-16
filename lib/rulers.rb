require "rulers/version"
require "rulers/array"

module Rulers
  class Application
    def call(env)
      arr = [1, 2, 3 ,4, 5]
      [200, {'Content-Type' => 'text/html'}, ["Hello world!! It's rulers!\n#{arr.yay}\n#{arr.yay(2)}"]]
    end
  end
end
