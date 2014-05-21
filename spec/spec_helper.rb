require 'ftpd'

module ServerSpec
  module GlobalHelpers
    def self.included(base)
      base.let(:client_ip) { '192.168.1.100' }
      base.let(:xml_file_name) { 'test.xml' }
      base.let(:xml_file_path) { "/#{xml_file_name}" }
    end
  end
end

RSpec.configure do |config|
  config.include ServerSpec::GlobalHelpers
end

Dir["./spec/support/**/*.rb"].each {|f| require f}