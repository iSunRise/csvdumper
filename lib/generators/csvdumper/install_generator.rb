require 'rails/generators/base'
require 'rails/generators/migration'

module Csvdumper
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      desc 'Installs Csvdumper'
      source_root File.expand_path('../templates', __FILE__)

      def copy_migration
        migration_template 'migration.rb', 'db/migrate/csvdumper_create_ip_locations.rb', migration_version: migration_version
      end

      def generate_model
        template 'ip_location.rb', 'app/models/csvdumper/ip_location.rb'
      end

      def rails5?
        Rails.version.start_with?('5')
      end

      def migration_version
        if rails5?
          "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
        end
      end

      def self.next_migration_number(dirname)
        if ActiveRecord::Base.timestamped_migrations
          Time.now.utc.strftime('%Y%m%d%H%M%S')
        else
          '%.3d' % (current_migration_number(dirname) + 1)
        end
      end
    end
  end
end