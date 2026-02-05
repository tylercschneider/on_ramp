require "onramp/flow"
require "onramp/dsl/step_builder"

module Onramp
  module Dsl
    class FlowBuilder
      def self.build(name, &)
        builder = new(name)
        builder.instance_eval(&)
        builder.to_flow
      end

      def initialize(name)
        @name = name
        @description = nil
        @steps = []
        @on_complete = nil
      end

      # rubocop:disable Style/TrivialAccessors -- DSL method, not a simple setter
      def description(value)
        @description = value
      end
      # rubocop:enable Style/TrivialAccessors

      def step(name, &)
        @steps << StepBuilder.build(name, &)
      end

      def on_complete(&block)
        @on_complete = block
      end

      def to_flow
        Flow.new(
          @name,
          description: @description,
          steps: @steps,
          on_complete: @on_complete
        )
      end
    end
  end
end
