require "rails/generators"
require "rails/generators/active_record"

module Onramp
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include ActiveRecord::Generators::Migration

      source_root File.expand_path("templates", __dir__)

      def create_migration
        migration_template "migration.rb.erb", "db/migrate/create_onramp_progresses.rb"
      end

      def create_initializer
        template "initializer.rb.erb", "config/initializers/onramp.rb"
      end

      def create_flows_directory
        empty_directory "app/onboarding/flows"
      end

      private

      def migration_version
        "[#{ActiveRecord::VERSION::STRING.to_f}]"
      end
    end
  end
end
