require 'ftpd'

require_relative 'lib/driver'
require_relative 'lib/command_parser'

class Server
  def initialize(argv)
    @args = CommandParser::Arguments.new(argv)
    make_log
    @driver = Driver.new(@args, @log)
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
    @server.log = @log
  end

  def display_connection_info
    puts "Interface: #{@server.interface}"
    puts "Port: #{@server.bound_port}"
    puts "PID: #{$$}"
  end

  def make_log
    @log = Logger.new('onu_ftp_filesystem.log', 10, 1024000)
    @log.level = @args.debug ? Logger::DEBUG : Logger::WARN
  end

  def wait_until_stopped
    puts 'GPON FTP server started. Press Ctrl+C to exit'
    $stdout.flush

    while true do
      begin
        #Explicit use of $stdin because we can provide outfile name as a command line argument
        $stdin.gets
      rescue Interrupt
        puts "\nExiting..."
        exit
      rescue => ex
        puts ex.backtrace
      end
    end
  end
end

Server.new(ARGV).run