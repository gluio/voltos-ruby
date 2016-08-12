require 'logger'
module Voltos
  module Logger
    @@levels = ["FATAL", "ERROR", "WARN", "INFO", "DEBUG"]
    @@levels.each do |level|
      define_singleton_method level.downcase.to_sym do |msg|
        logger.send(level.downcase.to_sym, 'Voltos Process - ' + msg)
      end
    end

    def self.logger
      return @logger if @logger
      @logger = ::Logger.new(STDOUT)
      @logger.level = ::Logger::WARN
      if level = ENV["LOG_LEVEL"]
        if @@levels.include? level.upcase
          @logger.level = ::Logger.const_get(level.upcase.to_sym)
        else
          @logger.warn "Log level '#{level.upcase}' is unknown. Supported levels are: #{levels.join(", ")}."
        end
      end
      @logger
    end
  end
end

