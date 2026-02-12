require 'on_ramp/version'
require 'on_ramp/step'
require 'on_ramp/flow'
require 'on_ramp/registry'

if defined?(Rails)
  require 'on_ramp/engine'
  require 'on_ramp/on_rampable'
end

module OnRamp
  class Configuration
    attr_accessor :flows_path, :progress_class, :association_name

    def initialize
      @flows_path = nil
      @progress_class = 'OnRamp::Progress'
      @association_name = :on_ramp_progresses
    end
  end

  class << self
    def config
      @config ||= Configuration.new
    end

    def configure
      yield(config)
    end

    def progress_class
      config.progress_class.constantize
    end
  end
end
