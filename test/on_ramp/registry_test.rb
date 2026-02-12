require 'test_helper'

module OnRamp
  class RegistryTest < OnRamp::TestCase
    def setup
      OnRamp::Registry.reset!
    end

    def test_registers_and_retrieves_a_flow
      flow = OnRamp::Flow.new(:default, description: 'Main flow')
      OnRamp::Registry.register(flow)

      assert_equal flow, OnRamp::Registry.find(:default)
    end

    def test_provides_bracket_accessor
      flow = OnRamp::Flow.new(:default)
      OnRamp::Registry.register(flow)

      assert_equal flow, OnRamp::Registry[:default]
    end

    def test_returns_all_registered_flows
      flow1 = OnRamp::Flow.new(:default)
      flow2 = OnRamp::Flow.new(:alternate)
      OnRamp::Registry.register(flow1)
      OnRamp::Registry.register(flow2)

      assert_equal 2, OnRamp::Registry.all.size
      assert_includes OnRamp::Registry.all.values, flow1
      assert_includes OnRamp::Registry.all.values, flow2
    end

    def test_registers_flow_using_dsl_block
      OnRamp::Registry.register_flow(:default) do
        description 'Main flow'

        step :welcome do
          title 'Welcome!'
        end
      end

      flow = OnRamp::Registry[:default]

      assert_equal :default, flow.name
      assert_equal 'Main flow', flow.description
      assert_equal 1, flow.steps.size
    end

    def test_reset_clears_all_flows
      OnRamp::Registry.register(OnRamp::Flow.new(:default))
      OnRamp::Registry.reset!

      assert_equal 0, OnRamp::Registry.all.size
    end
  end
end
