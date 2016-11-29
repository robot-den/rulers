require 'sqlite3'
require 'rulers/sqlite_model'

class Quotes < Rulers::Model::SQLite3; end
STDERR.puts Quotes.schema.inspect

# mt = Quotes.create 'title' => 'Wow', 'posted' => 1, 'body' => 'wow body'
# mt = Quotes.create 'title' => 'Wow3'
# mt['title'] = 'It saves new title!'
# mt.save!

mt2 = Quotes.find(24)
puts mt2.title
puts '-------------'
puts "Count: #{Quotes.count}"
top_id = Quotes.count
(1..top_id).each do |id|
  record = Quotes.find(id)
  puts "Founded: #{id} - '#{record['title']}'"
end
