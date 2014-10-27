module ConfigXmlBuilder
  module WlanBindBuilder
    def build_wlan_bind_configuration(xml, config)
      xml.wlan_bind_configuration do
        xml.fixed_flag 1
        xml.wlan_bind_configs do
          xml.DictionaryEntry do
            xml.Key 1, ClassID: 1, IsNewClass: 'true', ClassName: 'java.lang.Integer'
            xml.Value ClassID: 2, IsNewClass: 'true', ClassName: 'ONTProvision.wlan_bind_ssid_item' do
              xml.port 0
              xml.vid 0
              xml.cos 0
            end
          end

          for key in 2..4 do
            xml.DictionaryEntry do
            xml.Key key, ClassID: 1
            xml.Value ClassID: 2
              xml.port 0
              xml.vid 0
              xml.cos 0
            end
          end

        end
      end
    end
  end
end