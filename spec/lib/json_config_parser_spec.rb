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
    it 'responds to #parse method' do
      expect(parser).to respond_to(:parse)
    end

    it 'accepts :json String as parameter' do
      expect { parser.parse('{}') }.to_not raise_error
    end

    let(:json) { '{"val":"test","val1":"test1","val2":"test2"}' }
    let(:parsed_json) { parser.parse(json) }

    it 'returns configuration as Hash' do
      expect(parsed_json).to be_a Hash
    end

    its 'returned value contains valid keys' do
      expect(parsed_json.has_key?('val')).to be_true
    end

    its 'returned value contains proper values' do
      expect(parsed_json.has_value?('test2')).to be_true
    end
  end

end