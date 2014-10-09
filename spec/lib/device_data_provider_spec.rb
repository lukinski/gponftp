require 'spec_helper'

require_relative '../../lib/device_data_provider'

describe DeviceDataProvider do
  let(:provider) { DeviceDataProvider.new }

  describe '#new' do
    it 'is instance of DeviceDataProvider' do
      expect(provider).to be_a DeviceDataProvider
    end
  end

  describe '#ip_valid?' do
    it 'returns true for valid IP' do
      expect { provider.ip_valid?('127.0.0.1') }.to be_true
    end
    it 'returns false for invalid IP' do
      expect(provider.ip_valid?('a.b.c.d')).to be_false
      expect(provider.ip_valid?('')).to be_false
    end
  end

  describe '#get_data_by_ip' do
    it 'responds to get_data_by_ip method' do
      expect(provider).to respond_to(:get_data_by_ip)
    end

    it 'accepts (ip) as a parameter' do
     expect { provider.get_data_by_ip(client_ip) }.to_not raise_error
   end

   it 'raises error if IP not found' do
      expect { provider.get_data_by_ip('0.0.0.0') }.to raise_error
   end

   it 'returns empty hash for invalid IP' do
    expect(provider.get_data_by_ip('')).to eq({})
   end

   subject(:result) {  }
  end
end