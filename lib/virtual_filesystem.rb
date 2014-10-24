require_relative 'config_file_builder'

module Ftpd

  class VirtualFileSystem

    attr_accessor :client_ip

    def initialize(outfile, debug_mode = false, log = nil)
      @log = log
      @outfile_path = "/#{outfile}"
      @debug_mode = debug_mode
    end

    def get_content(ftp_path = nil)
      ConfigFileBuilder::ConfigBuilder.new(client_ip).get_content(ftp_path)
    end

    def is_content_file?(ftp_path)
      ftp_path.end_with?('.xml')
    end
  end

  module Accessors
    def accessible?(ftp_path)
      exists?(ftp_path)
    end

    def exists?(ftp_path)
      ftp_path.end_with?('.xml') || directory?(ftp_path)
    end

    def directory?(ftp_path)
      ['/', '.'].include?(ftp_path)
    end
  end

  module Read
    include Error

    def read(ftp_path)
      begin
        get_content(ftp_path)
      rescue => ex
        if @log != nil
          @log.warn ex.message
          @log.debug ex.backtrace
        end
        error '550 Access denied'
      end
    end
  end

  module List
    def file_info(ftp_path)
      ftype,mode = get_stat(ftp_path)

      FileInfo.new(ftype: ftype,
                   group: 'gpon',
                   identifier: '666.0000000',
                   mode: mode,
                   mtime: Time.new,
                   nlink: 1,
                   owner: 'gpon',
                   path: ftp_path,
                   size: 0)

    end

    def dir(ftp_path)
      ftp_path == '*' ? [] : [@outfile_path]
    end

    private

    def get_stat(ftp_path)
      is_content_file?(ftp_path) ? ['file', 0444] : ['directory', 0555]
    end
  end

  module Base
    include Accessors
  end

  class VirtualFileSystem
    include Base
    include List
    include Read
  end

end
