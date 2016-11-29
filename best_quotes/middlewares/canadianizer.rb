class Canadianizer
  def initialize(app, str = '')
    @app = app
    @str = str
  end

  def call(env)
    status, headers, content = @app.call(env)
    content[0] += @str + ', eh?'
    [status, headers, content]
  end
end
