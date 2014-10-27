require 'builder'
require 'date'

require_relative 'application_config'
require_relative 'device_data_provider'
require_relative 'builders/config_builder'

module ConfigFileBuilder
  class ConfigBuilder
    def initialize(client_ip = nil)
      @client_ip = client_ip
      @config = ApplicationConfig.new
    end

    def get_content(outfile_name = nil)
      @outfile_name = outfile_name
      @output = generate_xml
    end

    def generate_xml
      @xml = Builder::XmlMarkup.new(indent: 2)
      @xml.instruct! :xml, version: '1.0'
      device = get_device_data
      build_xml(device)
      @xml.target!
    end

    private

    def build_xml(device)
      @device = device
      @onu_attrs = @device['onu_attributes']

      @builder = ConfigXmlBuilder::ConfigBuilder.new(@xml, @device, @config)

      @xml.tag! 'ONTProvision.configuration' do
        @xml.client_ip @device[:ip]
        @xml.modified_time '2014-05-21 16:00:00'

        ConfigXmlBuilder.onu_attrs = @onu_attrs
        @builder.build_config_xml

      end
    end

    def get_device_data
      device_data_provider = DeviceDataProvider.new
      if(@outfile_name)
        serial_number = File.basename(@outfile_name, '.*')
        device_data_provider.get_data_by_sn(serial_number)
      else
        device_data_provider.get_data_by_ip(@client_ip)
      end
    end
  end
end
