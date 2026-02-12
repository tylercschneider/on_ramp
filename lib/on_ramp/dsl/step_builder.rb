require 'on_ramp/step'

module OnRamp
  module Dsl
    class StepBuilder
      def self.build(name, &)
        builder = new(name)
        builder.instance_eval(&)
        builder.to_step
      end

      def initialize(name)
        @name = name
        @title = nil
        @component = nil
        @show_if = nil
        @branches = []
        @after_complete = nil
      end

      # -- DSL methods, not simple setters
      def title(value)
        @title = value
      end

      def component(value)
        @component = value
      end

      def show_if(condition)
        @show_if = condition
      end

      def branches_to(target, if:)
        @branches << { to: target, if: binding.local_variable_get(:if) }
      end

      def after_complete(&block)
        @after_complete = block
      end

      def to_step
        Step.new(
          @name,
          title: @title,
          component: @component,
          show_if: @show_if,
          branches: @branches,
          after_complete: @after_complete
        )
      end
    end
  end
end
