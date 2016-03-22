begin
  module Voltos
    class Railtie < Rails::Railtie
      config.before_configuration { load }

      def load
        Voltos.configure
        Voltos.load
      end

      def root
        Rails.root || Pathname.new(ENV["RAILS_ROOT"] || Dir.pwd)
      end

      def self.load
        instance.load
      end
    end
  end
rescue NameError
  # Rails not loaded
end
