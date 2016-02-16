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
    env_str = Curl.get("http://voltos.online/v1/credentials") do |http|
      http.headers["Authorization"] = "Token token=#{Voltos.configuration.api_key}"
    end
    Voltos.configuration.envs = JSON.parse(env_str.body_str)
  end
  
  def self.keys
    Voltos.configuration.envs.keys
  end
  
  def self.key(env_key)
    Voltos.configuration.envs[env_key]
  end
  
  class Configuration
    attr_accessor :api_key
    attr_accessor :envs

    def initialize
      @api_key = ""
    end
  end
end
