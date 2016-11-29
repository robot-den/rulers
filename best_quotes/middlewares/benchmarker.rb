class Benchmarker
  def initialize(app, runs = 100)
    @app, @runs = app, runs
  end

  def call(env)
    start_time = Time.now

    result = nil
    @runs.times { result = @app.call(env) }
    result_time = Time.now - start_time
    STDERR.puts <<OUTPUT
Benchmarker:
  #{@runs} runs
  #{result_time.to_f} seconds total
  #{result_time.to_f * 1000.0 / @runs} msec/run
OUTPUT
    result
  end
end
