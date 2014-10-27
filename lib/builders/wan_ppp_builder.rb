module ConfigXmlBuilder
  module WanPppBuilder
    def build_wan_ppp_configuration(xml, device, config)
      xml.wan_ppp_configuration do
        xml.fixed_flag 0
        xml.wan_ipmode 0
        xml.pppoe 0
        xml.authtype 0
        xml.lcp_echo_interval 20
        xml.mtu 1492
        xml.user ''
        xml.passwd ''
      end
    end
  end
end