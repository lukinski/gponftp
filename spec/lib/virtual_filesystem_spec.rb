require 'spec_helper'

require_relative '../../lib/virtual_filesystem'

describe Ftpd::VirtualFileSystem do
  let(:virtual_filesystem) { Ftpd::VirtualFileSystem.new(xml_file_name) }

  # before(:each), as using let in before(:all) is deprecated
  before(:each) {
    virtual_filesystem.client_ip = client_ip
  }

  describe '#new' do
    it 'is instance of VirtualFileSystem' do
      expect(Ftpd::VirtualFileSystem.new('')).to be_a Ftpd::VirtualFileSystem
    end
  end

  context 'with output filename set' do
    describe '#client_ip' do
      it 'allows client IP to be set' do
        virtual_filesystem.client_ip = client_ip
        expect(virtual_filesystem.client_ip).to eq client_ip
      end
    end

    describe '#get_content' do
      its 'value contains client\'s IP address' do
        virtual_filesystem.client_ip = client_ip
        expect(virtual_filesystem.get_content).to match(/#{@client_ip}/)
      end
    end

    describe '#is_content_file?' do
      it 'returns TRUE for given XML file path' do
        expect(virtual_filesystem.is_content_file?(xml_file_path)).to be true
      end

      it 'returns TRUE for random XML file name' do
        random_xml_file = (0...12).map { (65 + rand(26)).chr }.join
        expect(virtual_filesystem.is_content_file?("/#{random_xml_file}.xml")).to be true
      end

      it 'returns FALSE for path other than XML file' do
        expect(virtual_filesystem.is_content_file?('/')).to be false
      end
    end
  end

  context 'when accessing path on server' do
    describe '#exists?' do
      it 'returns TRUE for XML file path' do
        expect(virtual_filesystem.exists?(xml_file_path)).to be true
      end

      it 'returns TRUE for root directory path' do
        expect(virtual_filesystem.exists?('/')).to be true
      end

      it 'returns TRUE for current directory path' do
        expect(virtual_filesystem.exists?('.')).to be true
      end

      it 'returns FALSE for any disallowed path' do
        expect(virtual_filesystem.exists?('../..')).to be false
        expect(virtual_filesystem.exists?('/root')).to be false
        expect(virtual_filesystem.exists?('dummy.txt')).to be false
      end
    end

    describe '#accessible?' do
      it 'returns TRUE for XML file path' do
        expect(virtual_filesystem.accessible?(xml_file_path)).to be true
      end

      it 'returns TRUE for root directory path' do
        expect(virtual_filesystem.accessible?('/')).to be true
      end

      it 'returns TRUE for current directory path' do
        expect(virtual_filesystem.accessible?('.')).to be true
      end

      it 'returns FALSE for any disallowed path' do
        expect(virtual_filesystem.accessible?('../..')).to be false
        expect(virtual_filesystem.accessible?('/root')).to be false
        expect(virtual_filesystem.accessible?('dummy.txt')).to be false
      end
    end

    describe '#directory?' do
      it 'returns FALSE for XML file path' do
        expect(virtual_filesystem.directory?(xml_file_path)).to be false
      end

      it 'returns FALSE for any path other than XML file' do
        expect(virtual_filesystem.directory?('../..')).to be false
        expect(virtual_filesystem.directory?('/root')).to be false
        expect(virtual_filesystem.directory?('dummy.txt')).to be false
      end
    end

    describe '#file_info' do
      it 'returns info with path to file' do
        expect(virtual_filesystem.file_info(xml_file_path).path).to eq xml_file_path
      end
    end
  end

end