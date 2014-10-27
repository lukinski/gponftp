module ConfigXmlBuilder
  module DhcpcBuilder
    def build_dhcp_configuration(xml, config)
      xml.dhcpc_configuration do
        xml.fixed_flag 0
        xml.dhcpc_configs do
          xml.DictionaryEntry do
            xml.Key 1, ClassID: 1
            xml.Value ClassID: 3, IsNewClass: 'true', ClassName: 'ONTProvision.ONTProvision.dhcpc_config_item' do
              xml.ipaddr ''
              xml.mac ''
            end
          end

          for key in 2..4 do
            xml.DictionaryEntry do
            xml.Key key, ClassID: 1
            xml.Value ClassID: 3
              xml.ipaddr ''
              xml.mac ''
            end
          end
        end
      end
    end
  end
end