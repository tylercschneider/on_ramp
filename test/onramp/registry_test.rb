require "test_helper"

class Onramp::RegistryTest < Onramp::TestCase
  def setup
    Onramp::Registry.reset!
  end

  def test_registers_and_retrieves_a_flow
    flow = Onramp::Flow.new(:default, description: "Main flow")
    Onramp::Registry.register(flow)

    assert_equal flow, Onramp::Registry.find(:default)
  end

  def test_provides_bracket_accessor
    flow = Onramp::Flow.new(:default)
    Onramp::Registry.register(flow)

    assert_equal flow, Onramp::Registry[:default]
  end

  def test_returns_all_registered_flows
    flow1 = Onramp::Flow.new(:default)
    flow2 = Onramp::Flow.new(:alternate)
    Onramp::Registry.register(flow1)
    Onramp::Registry.register(flow2)

    assert_equal 2, Onramp::Registry.all.size
    assert_includes Onramp::Registry.all.values, flow1
    assert_includes Onramp::Registry.all.values, flow2
  end

  def test_registers_flow_using_dsl_block
    Onramp::Registry.register_flow(:default) do
      description "Main flow"

      step :welcome do
        title "Welcome!"
      end
    end

    flow = Onramp::Registry[:default]
    assert_equal :default, flow.name
    assert_equal "Main flow", flow.description
    assert_equal 1, flow.steps.size
  end

  def test_reset_clears_all_flows
    Onramp::Registry.register(Onramp::Flow.new(:default))
    Onramp::Registry.reset!

    assert_equal 0, Onramp::Registry.all.size
  end
end
