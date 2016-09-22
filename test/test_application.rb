require_relative 'test_helper'

class TestApp < Rulers::Application
end

class RulersAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    TestApp.new
  end

  def test_request
    # get '/quotes/a_quote'
    #
    # assert last_response.ok?
    # assert last_response.body['Hello']
    # assert last_response.body['Denis Nazmutdinov']
  end
end
