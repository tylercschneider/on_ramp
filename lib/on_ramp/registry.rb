require "on_ramp/dsl/flow_builder"

module OnRamp
  module Registry
    class << self
      def register_flow(name, &)
        flow = Dsl::FlowBuilder.build(name, &)
        register(flow)
      end

      def register(flow)
        flows[flow.name] = flow
      end

      def find(name)
        flows[name]
      end

      def [](name)
        find(name)
      end

      def all
        flows
      end

      def reset!
        @flows = {}
      end

      private

      def flows
        @flows ||= {}
      end
    end
  end
end
