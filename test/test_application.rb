require_relative 'test_helper'
require_relative '../app/application'

class RulersAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    TestApp.new
  end

  def test_request
    get '/tests/index'

    assert last_response.ok?
    assert last_response.body['Hello']
    assert last_response.body['Rulers!!!']
  end
end
