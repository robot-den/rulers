require 'sqlite3'
require 'rulers/util'

DB = SQLite3::Database.new 'db/database.db'

module Rulers
  module Model
    class SQLite3
      def initialize(data = nil)
        @hash = data
      end

      def method_missing(method)
        if @hash.keys.include?(method.to_s)
          # when env loaded, we define method only once, and then use new method. Cool!
          self.class.class_eval do
            define_method(method) { @hash[method.to_s] }
          end
          return @hash[method.to_s]
        else
          super
        end
      end

      def self.find(id)
        row = DB.execute "SELECT #{schema.keys.join(',')} from #{table} WHERE id = #{id};"
        data = Hash[schema.keys.zip row[0]]
        self.new data
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end

      def self.to_sql(val)
        case val
        when Numeric
          val.to_s
        when String
          "'#{val}'"
        else
          raise "Can't change #{val.class} to SQL!"
        end
      end

      def self.create(values)
        values.delete 'id'
        keys = schema.keys - ['id']
        vals = keys.map { |key| values[key] ? to_sql(values[key]) : 'null' }
        DB.execute "INSERT INTO #{table} (#{keys.join(',')}) VALUES (#{vals.join(',')});"
        data = Hash[keys.zip vals]
        sql = "SELECT last_insert_rowid();"
        data['id'] = DB.execute(sql)[0][0]
        self.new data
      end

      def self.count
        DB.execute("SELECT COUNT(*) FROM #{table}")[0][0]
      end

      def self.table
        Rulers.to_underscore name
      end

      def self.schema
        return @schema if @schema
        @schema = {}
        DB.table_info(table) { |row| @schema[row['name']] = row['type'] }
        @schema
      end

      def save!
        unless @hash['id']
          self.class.create
          return true
        end
        fields = @hash.map { |k, v| "#{k}=#{self.class.to_sql(v)}" }.join(',')
        DB.execute "UPDATE #{self.class.table} SET #{fields} WHERE id = #{@hash['id']}"
        true
      end

      def save
        self.save! rescue false
      end
    end
  end
end
