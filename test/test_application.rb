require_relative 'test_helper'

class TestApp < Rulers::Application
end

class RulersAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    TestApp.new
  end

  def test_request
    get '/'

    assert last_response.ok?
    assert last_response.body['Hello']
  end

  def test_array
    get '/'

    assert last_response.ok?
    assert last_response.body['2']
  end
end
