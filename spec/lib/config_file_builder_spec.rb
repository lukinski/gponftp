require 'spec_helper'

require_relative '../../lib/config_file_builder'

describe ConfigFileBuilder::ConfigBuilder do
  let(:builder) { ConfigFileBuilder::ConfigBuilder.new(client_ip) }

  describe '#new' do
    it 'is instance of ConfigBuilder' do
      expect(builder).to be_a ConfigFileBuilder::ConfigBuilder
    end
  end

  context 'with XML file created' do
    subject(:xml) { builder.get_content }

    it 'contains XML 1.0 markup header' do
      should match(/xml version="1.0"/)
    end

    it 'contains ONTProvision.configuration branch' do
      should match(/<ONTProvision.configuration>.+<\/ONTProvision.configuration>/)
    end

    it 'contains modified_time branch with date and time' do
      should match(/<modified_time>.+<\/modified_time>/)
    end

    it_should_behave_like('xml file', 'wan_ppp_configuration', [
      '<fixed_flag>\d+<\/fixed_flag>',
      '<wan_ipmode>\d+<\/wan_ipmode>',
      '<pppoe>\d+<\/pppoe>',
      '<authtype>\d+<\/authtype>',
      '<lcp_echo_interval>\d+<\/lcp_echo_interval>',
      '<mtu>\d+<\/mtu>',
      '<user>?.+<\/user>',
      '<passwd>?.+<\/passwd>'
    ])

    it_should_behave_like('xml file', 'system_configuration', [
      '<fixed_flag>\d+<\/fixed_flag>',
      '<cfg_after_factory>\d+<\/cfg_after_factory>',
      '<web_port>\d+<\/web_port>',
      '<user_wan_cfg>\d+<\/user_wan_cfg>',
      '<admin_passwd>?.+<\/admin_passwd>',
      '<user_passwd>?.+<\/user_passwd>',
      '<gpon_passwd_method>.+<\/gpon_passwd_method>',
      '<gpon_passwd>?.+<\/gpon_passwd>',
      '<web_language>.+<\/web_language>',
      '<telnet_admin_passwd>?.+<\/telnet_admin_passwd>'
    ])

    it_should_behave_like('xml file', 'wlan_configuration', [
      '<fixed_flag>\d+<\/fixed_flag>',
      '<radio>\d+<\/radio>',
      '<mode>\d+<\/mode>',
      '<bandwidth>\d+<\/bandwidth>',
      '<wmm>\d+<\/wmm>',
      '<channel>\d+<\/channel>',
      '<txpower>\d+<\/txpower>',
      '<beacon_period>\d+<\/beacon_period>',
      '<country_code>.+<\/country_code>'
    ])

    it_should_behave_like 'xml file', 'wlan_bind_configuration', ['<fixed_flag>\d+<\/fixed_flag>']

    it_should_behave_like('xml file', 'wlan_bind_configs', [
      '<DictionaryEntry>.+<\/DictionaryEntry>',
      '<port>\d+<\/port>',
      '<vid>\d+<\/vid>',
      '<cos>\d+<\/cos>'
    ])

    it_should_behave_like('xml file', 'lan_configuration', [
      '<fixed_flag>\d+<\/fixed_flag>',
      '<local_ip>(?:[0-9]{1,3}\.){3}[0-9]{1,3}<\/local_ip>',
      '<subnetmask>(?:[0-9]{1,3}\.){3}[0-9]{1,3}<\/subnetmask>',
      '<dhcp_server>\d+<\/dhcp_server>',
      '<dhcp_iprange_start>(?:[0-9]{1,3}\.){3}[0-9]{1,3}<\/dhcp_iprange_start>',
      '<dhcp_iprange_end>(?:[0-9]{1,3}\.){3}[0-9]{1,3}<\/dhcp_iprange_end>',
      '<dhcp_leasetime>\d+<\/dhcp_leasetime>'
    ])

    it_should_behave_like('xml file', 'dhcpc_configuration', [
      '<fixed_flag>\d+<\/fixed_flag>',
      '<dhcpc_configs>.+<\/dhcpc_configs>'
    ])

    it_should_behave_like('xml file', 'dhcpc_configs', [
      '<DictionaryEntry>.+<\/DictionaryEntry>',
      '<ipaddr>?.+<\/ipaddr>',
      '<mac>?.+<\/mac>'
    ])

    it_should_behave_like('xml file', 'ssid_configuration', [
      '<fixed_flag>\d+<\/fixed_flag>'
    ])

    it_should_behave_like('xml file', 'ssid_configs', [
      '<DictionaryEntry>.+<\/DictionaryEntry>',
      '<name>.+<\/name>',
      '<maximum_connections>\d+<\/maximum_connections>',
      '<hidden_ssid>\d+<\/hidden_ssid>',
      '<authentication>\d+<\/authentication>',
      '<encryption>\d+<\/encryption>',
      '<selected_key>\d+<\/selected_key>',
      '<keys>.+<\/keys>',
      '<pre_shared_key>.+<\/pre_shared_key>',
      '<radius_server>?.+<\/radius_server>',
      '<password>?.+<\/password>',
      '<port>\d+<\/port>'
    ])

  end
end