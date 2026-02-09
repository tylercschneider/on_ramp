module OnRamp
  class Engine < ::Rails::Engine
    isolate_namespace OnRamp

    config.autoload_paths << File.expand_path("../..", __dir__)

    initializer "on_ramp.load_flows" do |app|
      app.config.to_prepare do
        OnRamp::Registry.reset!
        flows_path = OnRamp.config.flows_path
        if flows_path && Dir.exist?(flows_path)
          Dir[File.join(flows_path, "**/*.rb")].each { |f| load(f) }
        end
      end
    end
  end
end
