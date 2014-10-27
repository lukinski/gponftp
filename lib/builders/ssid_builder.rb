module ConfigXmlBuilder
  module SsidBuilder
    def build_ssid_configuration(xml, device, config)
      authentication, encryption, psk_key, wep_key = security_settings(device, config)

      xml.ssid_configuration do
        xml.fixed_flag 1
        xml.ssid_configs do
          xml.DictionaryEntry do
            xml.Key 1, ClassID: 1
            xml.Value ClassID: 4, IsNewClass: 'true', ClassName: 'ONTProvision.ssid_config_item' do
              xml.name ConfigXmlBuilder.attr('SSID', "INGRAM-device-#{device[:id]}")
              xml.maximum_connections 16
              xml.hidden_ssid 0
              xml.authentication authentication
              xml.encryption encryption
              xml.selected_key 1
              xml.keys do
                xml.DictionaryEntry do
                  xml.Key 1, ClassID: 1
                  xml.Value ClassID: 5, IsNewClass: 'true', ClassName: 'ONTProvision.ssid_key' do
                    xml.value wep_key
                  end
                end

                for key_entry_num in 2..4 do
                  add_ssid_config_key_dictionary_entry(xml, key_entry_num)
                end
              end
              xml.pre_shared_key psk_key #device[:wpa]
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

    def self.enc_id(encryption, default = 4)
      enc_types = {
        'NONE' => 0,
        'WEP' => 1,
        'TKIP' => 2,
        'AES' => 3,
        'AES+TKIP' => 4
      }
      (encryption && enc_types[encryption.upcase]) || default
    end

    def self.auth_id(authentication, default = 4)
      auth_types = {
        'NONE' => 0,
        'WPA-PROF' => 1,
        'WPA-PSK' => 2,
        'WPA2-PROF' => 3,
        'WPA2-PSK' => 4
      }
      (authentication && auth_types[authentication.upcase]) || default
    end

    private

    def security_settings(device, config)
      enc = ConfigXmlBuilder.attr('ENC_TYPE', config.xml['encryption'])
      auth = ConfigXmlBuilder.attr('AUTH_TYPE', config.xml['authentication'])
      wep_key = psk_key = ''
      enc == 'WEP' ? wep_key = device[:wpa] : psk_key = device[:wpa]

      encoding = SsidBuilder.enc_id(enc)
      authentication = SsidBuilder.auth_id(auth)

      return authentication, encoding, psk_key, wep_key
    end
  end
end