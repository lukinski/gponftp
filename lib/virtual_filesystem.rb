require_relative 'config_file_builder'

module Ftpd

  class VirtualFileSystem
    attr_accessor :client_ip

    def initialize(outfile)
      @outfile = outfile
    end

    def get_content
      ConfigFileBuilder::ConfigBuilder.new(client_ip).get_content
    end

    def is_content_file?(ftp_path)
      ftp_path == "/#{@outfile}"
    end

  end

  module Accessors
    def accessible?(ftp_path)
      exists?(ftp_path)
    end

    def exists?(ftp_path)
      ['/', '.', "/#{@outfile}"].include?(ftp_path)
    end

    def directory?(ftp_path)
      ftp_path != @outfile
    end
  end

  module Read
    def read(ftp_path)
      get_content
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
      flist = ftp_path == '*' ? [] : ["/#{@outfile}"]
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
