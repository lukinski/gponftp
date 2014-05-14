require 'spec_helper'
require 'builder'

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
      xml.instruct!
      xml.device_config do
        xml.ip device[:ip]
      end

      xml.target!
    end

    def get_device_data
      {ip: @client_ip}
    end
  end
end
