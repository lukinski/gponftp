require 'json'

class JsonConfigParser
  def parse(json)
    attrs = JSON.parse(json)
    common = attrs['common_attributes']
    custom = attrs['custom_attributes']

    common.merge(custom)
  end
end