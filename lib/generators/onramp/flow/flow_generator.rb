require "rails/generators"

module Onramp
  module Generators
    class FlowGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      def create_flow_file
        template "flow.rb.erb", "app/onboarding/flows/#{file_name}_flow.rb"
      end

      private

      def flow_name
        file_name
      end

      def class_name_underscored
        file_name
      end
    end
  end
end
