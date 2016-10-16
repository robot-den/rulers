class TestsController < Rulers::Controller
  def index
    @framework = 'Rulers!!!'
    render :index
  end
end
