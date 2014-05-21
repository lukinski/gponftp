require 'yaml'

class ApplicationConfig
  def initialize
    YAML.load_file('config.yaml').each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def method_missing(method, *args, &block)
    instance_variable_get("@#{method}") || ''
  end
end