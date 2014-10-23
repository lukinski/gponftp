require_relative 'database_connector'
require_relative 'json_config_parser'

class DeviceDataProvider
  def initialize
    @db = DatabaseConnector.instance
  end

  def get_data_by_sn(serial_number)
    sn = @db.escape(serial_number).downcase
    fetch_device_data base_query("LOWER(onu_number)='#{sn}'")
  end

  def get_data_by_ip(ip)
    # TESTING ONLY - REMOVE!!!
    ip = '192.168.3.2' if (ip == '83.1.224.3' || ip == '192.168.251.101')
    return {} if !ip_valid?(ip)
    fetch_device_data_by_ip(ip)
  end

  def ip_valid?(ip)
    !!(ip =~ /\A\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\Z/)
  end

  def get_onu_attributes(serial_number)
    attrs = fetch_device_onu_attributes(serial_number)
    JsonConfigParser.new.parse attrs
  end

  private

  def base_query(where)
    "SELECT
      id,
      INET_NTOA(ip) ip,
      DATE_FORMAT(modification_date + ' 00:00:00', '%Y-%m-%d %H:%i:%s') modification_date,
      IFNULL(local_access_key, '') wpa
    FROM clients_devices WHERE #{where} LIMIT 1"
  end

  def fetch_device_data_by_ip(ip)
    ip = @db.get_connection.escape(ip)
    fetch_device_data base_query("ip=INET_ATON('#{ip}')")
  end

  def fetch_device_data(query)
    result = @db.execute(query)
    result.first
  end

  def fetch_device_onu_attributes(sn)
    sn = @db.get_connection.escape(sn)
    query = "SELECT getDeviceOnuConfigJson('#{sn}') attributes"
    result = @db.execute(query)
    raise "Device not found" if result.first[:attributes] == nil
    result.first[:attributes]
  end
end
