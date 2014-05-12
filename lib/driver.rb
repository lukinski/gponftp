require_relative 'custom_ftpd'
require_relative 'virtual_filesystem'

class Driver
  def initialize(args)
    @args = args
  end

  def authenticate(user, password)
    true
  end

  def file_system(user)
    Ftpd::VirtualFileSystem.new(@args)
  end
end