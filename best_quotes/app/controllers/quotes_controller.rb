class QuotesController < Rulers::Controller
  def show
    @quote = Quotes.find(params['id'])
  end

  def index
    @quotes = FileModel.find_all_by_submitter 'Den'
    @schema = Quotes.schema
  end

  def new_quote
    attrs = {
      "submitter" => "Den",
      "quote" => "No money - no honey",
      "attribution" => "People"
    }

    @quote = FileModel.create attrs
    render :a_quote
  end

  def update
    fail if @env['REQUEST_METHOD'] != 'POST'
    id = 1
    quote = FileModel.find(id)
    quote[:submitter] = 'john'
    quote.update
  end

  def exception
    raise 'Oh, no!'
  end
end
