module RailsGraylog
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def copy_graylog_initializer
        copy_file 'graylog.rb', 'config/initializers/graylog.rb'
        puts 'Please set GRAYLOG_HOST, GRAYLOG_PORT in your environment variables'
      end
    end
  end
end
