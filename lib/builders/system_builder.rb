module ConfigXmlBuilder
  module SystemBuilder
    def build_system_configuration(xml, device, config)
      xml.system_configuration do
        xml.fixed_flag 1
        xml.cfg_after_factory 1
        xml.web_port 8080
        xml.user_wan_cfg 2
        xml.admin_passwd config.xml['admin_password']
        xml.user_passwd config.xml['user_password']
        xml.gpon_passwd_method 0
        xml.gpon_passwd ''
        xml.web_language 'english'
        xml.telnet_admin_passwd config.xml['telnet_admin_password']
      end
    end
  end
end