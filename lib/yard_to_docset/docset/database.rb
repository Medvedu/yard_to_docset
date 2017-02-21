# encoding: utf-8
# frozen_string_literal: true
module YardToDocset
module Docset
  class Database
    def initialize(constructor)
      @constructor = constructor
    end

    def seed
      connect_to_db
      seed_sqlite3
    end

    private

    # @return [Docset::Constructor]
    attr_reader :constructor

    # @return [SQLite3::Database]
    attr_reader :database

    def records
      constructor.parser.records
    end

    def connect_to_db
      @database = SQLite3::Database.new(constructor.structure.path_to_database.to_s)
      @database.execute(
        'CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT)')
    end

    # @param [String] name
    # @param [String] type
    # @param [String] path

    def add_to_database(name, type, path)
      sql_command =
        "insert into searchIndex (name, type, path) VALUES(?, ?, ?)"

      database.execute sql_command, name, type, path
    end

    def seed_sqlite3
      records.each { |record| add_to_database *record }
    end
  end # class Database
end # module Docset
end # module YardToDocset
