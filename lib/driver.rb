require_relative 'custom_ftpd'
require_relative 'virtual_filesystem'

class Driver
  def initialize(args)
    @args = args
    @config = ApplicationConfig.new
  end

  def authenticate(user, password)
    user == @config.ftp['user_login'] && password == @config.ftp['user_password']
  end

  def file_system(user)
    Ftpd::VirtualFileSystem.new(get_outfile_name)
  end

  private

  def get_outfile_name
    @args.outfile || 'gpon_config.xml'
  end
end
