require 'json'

class JsonConfigParser
  def parse(json)
    JSON.parse(json)
  end
end