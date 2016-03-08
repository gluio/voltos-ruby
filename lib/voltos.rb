require "voltos/version"

require "curb"
require "json"

module Voltos
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end

  def self.load
    json_str = Curl.get("#{Voltos.configuration.api_url}/credentials") do |http|
      http.headers["Authorization"] = "Token token=#{Voltos.configuration.api_key}"
    end
    data = JSON.parse(json_str.body_str)
    if data.has_key?("status")
      Voltos.configuration.json_creds = data
      Voltos.configuration.status  = Voltos.configuration.json_creds["status"]
      Voltos.configuration.message = Voltos.configuration.json_creds["message"]
    else
      data.each do |key, val|
        ENV[key] ||= val
      end
    end
  end

  def self.bundles
    Voltos.configuration.json_creds["data"]["bundles"].keys
  end

  def self.key(bundle_name, env_key)
    if not bundle_name.empty?
      Voltos.configuration.json_creds["data"]["bundles"][bundle_name][env_key]
    else
      Voltos.configuration.json_creds["data"]["unbundled"][env_key]
    end
  end

  def self.status
    return Voltos.configuration.status
  end

  def self.message
    return Voltos.configuration.message
  end

  class Configuration
    attr_accessor :api_key
    attr_accessor :api_url
    attr_accessor :json_creds
    attr_accessor :status
    attr_accessor :message

    def initialize
      @api_url = ENV["VOLTOS_API_URL"] || "https://voltos.online/v1"
      @api_key = ENV["VOLTOS_API_KEY"]
    end
  end
end

Voltos.configure
if ENV["VOLTOS_API_KEY"]
  Voltos.load
end
