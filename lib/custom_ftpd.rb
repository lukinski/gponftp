module Ftpd
  class Session
    attr_accessor :client_ip

    private
    def cmd_retr(path)
      close_data_server_socket_when_done do
        ensure_logged_in
        ensure_file_system_supports :read
        syntax_error unless path
        path = File.expand_path(path, @name_prefix)
        ensure_accessible path
        ensure_exists path
        @file_system.client_ip = client_ip
        contents = @file_system.read(path)
        transmit_file contents
      end
    end
  end

  class ConnectionTracker
    def client_ip(socket)
      peer_ip(socket)
     end
  end

  class FtpServer
    def run_session(socket)
      config = SessionConfig.new
      config.allow_low_data_ports = @allow_low_data_ports
      config.auth_level = @auth_level
      config.driver = @driver
      config.failed_login_delay = @failed_login_delay
      config.list_formatter = @list_formatter
      config.log = @log
      config.max_failed_logins = @max_failed_logins
      config.response_delay = response_delay
      config.server_name = @server_name
      config.server_version = @server_version
      config.session_timeout = @session_timeout
      config.tls = @tls
      session = Session.new(config, socket)
      session.client_ip = @connection_tracker.client_ip(socket)
      session.run
    end
  end
end