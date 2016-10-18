require 'multi_json'

module Rulers
  module Model
    class FileModel
      def initialize(filename)
        @filename = filename
        @id = File.basename(filename, '.json').to_i
        obj = File.read(filename)
        @hash = MultiJson.load(obj)
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end

      def self.find(id)
        begin
          FileModel.new("db/quotes/#{id}.json")
        rescue
          nil
        end
      end

      def self.all
        files = Dir["db/quotes/*.json"]
        files.map { |f| FileModel.new f }
      end

      def self.create(attrs)
        hash = {}
        hash[:submitter] = attrs["submitter"] || ""
        hash[:quote] = attrs["quote"] || ""
        hash[:attribution] = attrs["attribution"] || ""

        files = Dir["db/quotes/*.json"]
        max_id = files.map { |f| File.basename(f, '.json').to_i }.max
        new_file = "db/quotes/#{max_id + 1}.json"
        File.open(new_file, 'w') do |f|
          f.write <<TEMPLATE
{
  "submitter": "#{hash[:submitter]}",
  "quote": "#{hash[:quote]}",
  "attribution": "#{hash[:attribution]}"
}
TEMPLATE
        end
        FileModel.new(new_file)
      end
    end
  end
end
