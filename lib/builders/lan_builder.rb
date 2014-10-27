module ConfigXmlBuilder
  module LanBuilder
    def build_lan_configuration(xml, config)
      xml.lan_configuration do
        xml.fixed_flag 0
        xml.local_ip '192.168.1.100'
        xml.subnetmask '255.255.255.0'
        xml.dhcp_server 1
        xml.dhcp_iprange_start '192.168.1.101'
        xml.dhcp_iprange_end '192.168.1.200'
        xml.dhcp_leasetime 86400
      end
    end
  end
end