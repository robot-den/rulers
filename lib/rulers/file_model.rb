require 'multi_json'

module Rulers
  module Model
    class FileModel
      @@cache = {}

      def initialize(filename)
        @filename = filename
        @id = File.basename(filename, '.json').to_i
        obj = File.read(filename)
        @hash = MultiJson.load(obj)
        @cache = {}
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end

      class << self
        def find(id)
          begin
            @@cache[id] ||= FileModel.new("db/quotes/#{id}.json")
          rescue
            nil
          end
        end

        def all
          files = Dir["db/quotes/*.json"]
          files.map { |f| FileModel.new f }
        end

        def create(attrs)
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

        def find_all_by_attr(attribute, value)
          if ['submitter', 'quote', 'attribution'].include?(attribute)
            all.select { |f| f[attribute] == value }
          else
            raise "Undefined attribute: #{attribute}"
          end
        end

        def method_missing(method_name, *args, &block)
          match = method_name.to_s.match(/^find_all_by_(.*)/)
          if match
            find_all_by_attr(match[1], args[0])
          else
            super
          end
        end

        def respond_to_missing?(method_name, include_private = false)
          method_name.to_s.match(/^find_all_by_(.*)/) || super
        end
      end

      def update
        File.open(@filename, 'w') { |f| f.write MultiJson.dump(@hash) }
        FileModel.new(@filename)
      end
    end
  end
end
