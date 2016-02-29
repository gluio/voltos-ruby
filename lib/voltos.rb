require "voltos/version"

require "curb"
require "json"

module Voltos
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
  
  def self.foobar
    puts "API key is: #{Voltos.configuration.api_key}"
  end
  
  def self.load
    json_str = Curl.get("https://voltos.online/v1/credentials") do |http|
      http.headers["Authorization"] = "Token token=#{Voltos.configuration.api_key}"
    end
    Voltos.configuration.json_creds = JSON.parse(json_str.body_str)
    Voltos.configuration.status  = Voltos.configuration.json_creds["status"]
    Voltos.configuration.message = Voltos.configuration.json_creds["message"]
  end
  
  def self.keys
    Voltos.configuration.json_creds.keys
  end
  
  def self.key(bundle_name, env_key)
    if not bundle_name.empty?
      Voltos.configuration.json_creds["data"]["bundles"][bundle_name][env_key]
    else
      Voltos.configuration.json_creds["data"]["unbundled"][env_key]
    end
  end
  
  class Configuration
    attr_accessor :api_key
    attr_accessor :json_creds
    attr_accessor :status
    attr_accessor :message

    def initialize
      @api_key = ""
    end
  end
end
