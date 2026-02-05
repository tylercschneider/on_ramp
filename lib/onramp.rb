require "onramp/version"
require "onramp/step"
require "onramp/flow"
require "onramp/registry"

if defined?(Rails)
  require "onramp/engine"
  require "onramp/onrampable"
end

module Onramp
  class Configuration
    attr_accessor :flows_path, :progress_class, :association_name

    def initialize
      @flows_path = nil
      @progress_class = "Onramp::Progress"
      @association_name = :onramp_progresses
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
