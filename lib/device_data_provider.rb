require 'mysql2'

require_relative 'application_config'

class DeviceDataProvider
  def initialize
    @config = ApplicationConfig.new
    @db = Mysql2::Client.new(
      host: @config.database['host'],
      username: @config.database['username'],
      password: @config.database['password'],
      database: @config.database['dbname']
    )
  end

  def get_data_by_ip(ip)
    # TESTING ONLY - REMOVE!!!
    # ip = '192.168.3.2' if (ip == '83.1.224.3' || ip == '192.168.251.101')
    return {} if !ip_valid?(ip)
    fetch_device_data(ip)
  end

  def ip_valid?(ip)
    !!(ip =~ /\A\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\Z/)
  end

  private

  def fetch_device_data(ip)
    ip = @db.escape(ip)
    result = @db.query("SELECT
      id,
      '#{ip}' ip,
      DATE_FORMAT(modification_date + ' 00:00:00', '%Y-%m-%d %H:%i:%s') modification_date,
      IFNULL(local_access_key, '') wpa
    FROM clients_devices WHERE ip=INET_ATON('#{ip}') LIMIT 1", symbolize_keys: true)

    raise "Device not found: #{ip}" if result.count == 0
    result.first
  end
end
