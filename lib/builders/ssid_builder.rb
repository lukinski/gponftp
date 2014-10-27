module ConfigXmlBuilder
  module SsidBuilder
    def build_ssid_configuration(xml, device, config)

      xml.ssid_configuration do
        xml.fixed_flag 1
        xml.ssid_configs do
          xml.DictionaryEntry do
            xml.Key 1, ClassID: 1
            xml.Value ClassID: 4, IsNewClass: 'true', ClassName: 'ONTProvision.ssid_config_item' do
              xml.name ConfigXmlBuilder::attr('SSID', "INGRAM-device-#{device[:id]}")
              xml.maximum_connections 16
              xml.hidden_ssid 0
              xml.authentication 4
              xml.encryption 4
              xml.selected_key 1
              xml.keys do
                xml.DictionaryEntry do
                  xml.Key 1, ClassID: 1
                  xml.Value ClassID: 5, IsNewClass: 'true', ClassName: 'ONTProvision.ssid_key' do
                    xml.value ''
                  end
                end

                for key_entry_num in 2..4 do
                  add_ssid_config_key_dictionary_entry(xml, key_entry_num)
                end
              end
              xml.pre_shared_key device[:wpa]
              xml.radius_server ''
              xml.password ''
              xml.port 1
            end
          end
          for entry_num in 2..4 do
            add_ssid_config_dictionary_entry(xml, entry_num)
          end
        end
      end
    end

    def add_ssid_config_dictionary_entry(xml, entry_num)
      xml.DictionaryEntry do
        xml.Key entry_num, ClassID: 1
        xml.Value ClassID: 4 do
          xml.name ''
          xml.maximum_connections 16
          xml.hidden_ssid 0
          xml.authentication 0
          xml.encryption 0
          xml.selected_key 1
          for entry_num in 1..4 do
            add_ssid_config_key_dictionary_entry(xml, entry_num)
          end
          xml.pre_shared_key ''
          xml.radius_server ''
          xml.password ''
          xml.port ''
        end
      end
    end

    def add_ssid_config_key_dictionary_entry(xml, entry_num)
      xml.Key entry_num, ClassID: 1
      xml.Value ClassID: 5 do
        xml.value ''
      end
    end
  end
end