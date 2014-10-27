module ConfigXmlBuilder
  module WlanBuilder
    def build_wlan_configuration(xml, config)
      xml.wlan_configuration do
        xml.fixed_flag 1
        xml.radio 1
        xml.mode 4
        xml.bandwidth 20
        xml.wmm 1
        xml.channel 0
        xml.txpower 16
        xml.beacon_period 100
        xml.country_code 'PL'
      end
    end
  end
end