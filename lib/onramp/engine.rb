module Onramp
  class Engine < ::Rails::Engine
    isolate_namespace Onramp

    config.autoload_paths << File.expand_path("../..", __dir__)

    initializer "onramp.load_flows" do |app|
      app.config.to_prepare do
        Onramp::Registry.reset!
        flows_path = Onramp.config.flows_path
        if flows_path && Dir.exist?(flows_path)
          Dir[File.join(flows_path, "**/*.rb")].each { |f| load(f) }
        end
      end
    end
  end
end
