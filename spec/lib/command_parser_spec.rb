require 'spec_helper'

require_relative '../../lib/command_parser'

describe CommandParser::Arguments do
  describe '#new' do
    it 'is instance of Arguments' do
      expect(CommandParser::Arguments.new([])).to be_a CommandParser::Arguments
    end

    it 'exits with invalid option' do
      expect(lambda { CommandParser::Arguments.new(['--dummy']) }).to raise_error SystemExit
    end
  end

  context 'called with default values' do
    let(:args) { CommandParser::Arguments.new([]) }

    it 'has predefined option values assigned' do
      expect(args.interface).to eq '127.0.0.1'
      expect(args.port).to eq 21
      expect(args.debug).to_not be true
      expect(args.outfile).to be nil
    end
  end

  context 'called with specified option values' do
    let(:options) {[
      '-i', '192.168.1.1',
      '-p', '2121',
      '-d',
      '-o', 'dummy.file'
    ]}

    let(:args) { CommandParser::Arguments.new(options) }

    it 'has proper option values assigned' do
      expect(args.interface).to eq '192.168.1.1'
      expect(args.port).to eq 2121
      expect(args.debug).to be true
      expect(args.outfile).to eq 'dummy.file'
    end
  end
end