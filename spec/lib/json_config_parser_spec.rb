require 'spec_helper'

require_relative '../../lib/json_config_parser'

describe JsonConfigParser do
  let(:parser) { JsonConfigParser.new }

  describe '#new' do
    it 'is instance of JsonConfigParser' do
      expect(parser).to be_a JsonConfigParser
    end
  end

  describe '#parse' do
     let(:json) { '{"common_attributes": {"SSID": "ingram-DEVICE-12345", "WPA": "DummyWPA", "PPPOE_USER": "user_12345", "PPPOE_PASSWORD": "dummy_password_123", "ENC_TYPE": "WPA2", "ENABLE_NAT": "true", "WAN_TYPE": "dhcp"}, "custom_attributes": {"ENC_TYPE":"WEP","ENABLE_NAT":"true","WAN_TYPE":"static","LAN_IP":"127.0.0.1"}}' }

    it 'responds to #parse method' do
      expect(parser).to respond_to(:parse)
    end

    it 'accepts :json String as parameter' do
      expect { parser.parse(json) }.to_not raise_error
    end

    let(:parsed_json) { parser.parse(json) }

    it 'returns configuration as Hash' do
      expect(parsed_json).to be_a Hash
    end

    its 'returned value contains valid keys' do
      expect(parsed_json.has_key?('SSID')).to be_true
    end

    its 'returned value contains proper values' do
      expect(parsed_json.has_value?('ingram-DEVICE-12345')).to be_true
    end

    it 'properly handles custom attributes' do
      expect(parsed_json['WAN_TYPE']).to eq 'static'
    end

    it 'raise error with invalid JSON' do
      expect { parser.parse('{ "a": "invalid') }.to raise_error
    end
  end

end