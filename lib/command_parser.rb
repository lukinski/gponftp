require 'optparse'

module CommandParser
  class Arguments

    attr_reader :debug
    attr_reader :interface
    attr_reader :port
    attr_reader :outfile

    def initialize(argv)
      @interface = '127.0.0.1'
      @port = 21
      @debug = nil
      @outfile = nil

      op = option_parser
      op.parse!(argv)

    rescue OptionParser::ParseError => e
      $stderr.puts e
      exit(1)
    end

    private

    def option_parser
      op = OptionParser.new do |op|
        op.on('-p', '--port N', Integer, 'Bind to a specific port') do |t|
          @port = t
        end
        op.on('-i', '--interface IP', 'Bind to a specific interface') do |t|
          @interface = t
        end
         op.on('-o', '--outfile FILE', 'Serve file with given name') do |t|
          @outfile = t
        end
        op.on('-d', '--debug', 'Write server debug log to stdout') do |t|
          @debug = t
        end
      end
    end

  end
end