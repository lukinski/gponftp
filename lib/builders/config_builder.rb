Dir[File.dirname(__FILE__) + '/*.rb'].each {|file| require_relative file }

module ConfigXmlBuilder
  @onu_attrs = nil

  class << self
    attr_accessor :onu_attrs
  end

  def self.attr(key, default)
    @onu_attrs && @onu_attrs.has_key?(key) ? @onu_attrs[key] : default
  end

  class ConfigBuilder
    include SsidBuilder
    include WanPppBuilder
    include SystemBuilder, WlanBuilder, WlanBindBuilder, LanBuilder, DhcpcBuilder

    def initialize(xml, device, config)
      @xml = xml
      @device = device
      @config = config
    end

    def build_config_xml
      build_wan_ppp_configuration(@xml, @device, @config)
      build_system_configuration(@xml, @device, @config)
      build_wlan_configuration(@xml, @config)
      build_wlan_bind_configuration(@xml, @config)
      build_lan_configuration(@xml, @config)
      build_dhcp_configuration(@xml, @config)
      build_ssid_configuration(@xml, @device, @config)
    end
  end
end