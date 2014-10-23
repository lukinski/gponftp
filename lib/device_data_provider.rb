require_relative 'database_connector'

class DeviceDataProvider
  def initialize
    @db = DatabaseConnector.instance.get_connection
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
    ip = @db.escape(ip)
    fetch_device_data base_query("ip=INET_ATON('#{ip}')")
  end

  def fetch_device_data(query)
    result = @db.query(query, symbolize_keys: true)

    raise "Device not found" if result.count == 0
    result.first
  end
end
