require 'spec_helper'

require_relative '../../lib/config_file_builder'

describe ConfigFileBuilder::ConfigBuilder do
  let(:builder) { ConfigFileBuilder::ConfigBuilder.new(client_ip) }

  describe '#new' do
    it 'is instance of ConfigBuilder' do
      expect(builder).to be_a ConfigFileBuilder::ConfigBuilder
    end
  end

  describe '#get_content' do
    it 'returns XML containg IP address' do
      expect(builder.get_content).to match(/#{client_ip}/)
    end
  end
end