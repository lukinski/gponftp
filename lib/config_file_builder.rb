require 'builder'
require 'date'

module ConfigFileBuilder
  class ConfigBuilder
    def initialize(client_ip)
      @client_ip = client_ip
    end

    def get_content
      @output = generate_xml
    end

    private

    def generate_xml
      device = get_device_data

      xml = Builder::XmlMarkup.new
      xml.instruct! :xml, version: '1.0'
      xml.tag! 'ONTProvision.configuration' do
        xml.modified_time '2014-05-20 12:00:00'

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

        xml.system_configuration do
          xml.fixed_flag 1
          xml.cfg_after_factory 1
          xml.web_port 8080
          xml.user_wan_cfg 1
          xml.admin_passwd ''
          xml.user_passwd ''
          xml.gpon_passwd_method 0
          xml.gpon_passwd ''
          xml.web_language 'english'
          xml.telnet_admin_passwd ''
        end

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

        xml.lan_configuration do
          xml.fixed_flag 0
          xml.local_ip '192.168.1.100'
          xml.subnetmask '255.255.255.0'
          xml.dhcp_server 1
          xml.dhcp_iprange_start '192.168.1.101'
          xml.dhcp_iprange_end '192.168.1.200'
          xml.dhcp_leasetime 86400
        end

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

        xml.ssid_configuration do
          xml.fixed_flag 1
          xml.ssid_configs do
            xml.DictionaryEntry do
              xml.Key 1, ClassID: 1
              xml.Value ClassID: 4, IsNewClass: 'true', ClassName: 'ONTProvision.ssid_config_item' do
                xml.name 'INGRAM-device-{# device_id #}'
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
                xml.pre_shared_key '{# wpa #}'
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

      xml.target!
    end

    def get_device_data
      {ip: @client_ip}
    end

    private

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
