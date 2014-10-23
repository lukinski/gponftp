require 'singleton'
require 'mysql2'

require_relative 'application_config'

class DatabaseConnector
  include Singleton

  def initialize
    config = ApplicationConfig.new
    @db = Mysql2::Client.new(
      host: config.database['host'],
      username: config.database['username'],
      password: config.database['password'],
      database: config.database['dbname']
    )
  end

  def get_connection
    @db
  end

  def execute(query, symbolize = true)
    result = @db.query(query, symbolize_keys: symbolize)
    raise "Record not found" if result.count == 0
    result
  end
end