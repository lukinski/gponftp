require 'ftpd'
require_relative 'lib/driver'
require_relative 'lib/command_parser.rb'

class Server
  def initialize(argv)
    @args = CommandParser::Arguments.new(argv)
    @driver = Driver.new(@args)
    @server = Ftpd::FtpServer.new(@driver)
    configure_server
  end

  def run
    @server.start
    display_connection_info
    wait_until_stopped
  end

  def configure_server
    @server.interface = @args.interface
    @server.port = @args.port
    @server.log = make_log
  end

  def display_connection_info
    puts "Interface: #{@server.interface}"
    puts "Port: #{@server.bound_port}"
    puts "PID: #{$$}"
  end

  def make_log
    @args.debug && Logger.new($stdout)
  end

  def wait_until_stopped
    puts 'GPON FTP server started. Press ctrl+C to exit'
    $stdout.flush

    begin
      #Explicit use of $stdin because we can provide outfile name as a command line argument
      $stdin.gets while true
    rescue Interrupt
      puts "\nExiting..."
    end
  end
end

Server.new(ARGV).run