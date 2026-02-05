require "test_helper"

class Onramp::Dsl::FlowBuilderTest < Onramp::TestCase
  def test_builds_flow_with_description
    flow = Onramp::Dsl::FlowBuilder.build(:default) do
      description "Main onboarding"
    end

    assert_equal :default, flow.name
    assert_equal "Main onboarding", flow.description
  end

  def test_builds_flow_with_steps
    flow = Onramp::Dsl::FlowBuilder.build(:default) do
      step :welcome do
        title "Welcome!"
      end

      step :complete do
        title "Done"
      end
    end

    assert_equal 2, flow.steps.size
    assert_equal :welcome, flow.steps.first.name
    assert_equal "Welcome!", flow.steps.first.title
    assert_equal :complete, flow.steps.last.name
  end

  def test_builds_flow_with_on_complete_callback
    result = []
    flow = Onramp::Dsl::FlowBuilder.build(:default) do
      on_complete { |ctx| result << ctx[:done] }
    end

    flow.run_on_complete({done: true})

    assert_equal [true], result
  end
end
