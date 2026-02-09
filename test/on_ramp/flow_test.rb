require "test_helper"

class OnRamp::FlowTest < OnRamp::TestCase
  def test_initializes_with_name_and_description
    flow = OnRamp::Flow.new(:default, description: "Main onboarding")

    assert_equal :default, flow.name
    assert_equal "Main onboarding", flow.description
  end

  def test_holds_ordered_collection_of_steps
    step1 = OnRamp::Step.new(:welcome, title: "Welcome")
    step2 = OnRamp::Step.new(:complete, title: "Done")
    flow = OnRamp::Flow.new(:default, steps: [step1, step2])

    assert_equal 2, flow.steps.size
    assert_equal :welcome, flow.steps.first.name
    assert_equal :complete, flow.steps.last.name
  end

  def test_finds_step_by_name
    step1 = OnRamp::Step.new(:welcome, title: "Welcome")
    step2 = OnRamp::Step.new(:complete, title: "Done")
    flow = OnRamp::Flow.new(:default, steps: [step1, step2])

    assert_equal step2, flow.find_step(:complete)
    assert_nil flow.find_step(:nonexistent)
  end

  def test_returns_first_step
    step1 = OnRamp::Step.new(:welcome, title: "Welcome")
    step2 = OnRamp::Step.new(:complete, title: "Done")
    flow = OnRamp::Flow.new(:default, steps: [step1, step2])

    assert_equal step1, flow.first_step
  end

  def test_returns_next_step_in_sequence
    step1 = OnRamp::Step.new(:welcome, title: "Welcome")
    step2 = OnRamp::Step.new(:choose, title: "Choose")
    step3 = OnRamp::Step.new(:complete, title: "Done")
    flow = OnRamp::Flow.new(:default, steps: [step1, step2, step3])

    assert_equal step2, flow.next_step(:welcome, {})
    assert_equal step3, flow.next_step(:choose, {})
    assert_nil flow.next_step(:complete, {})
  end

  def test_next_step_follows_branch_when_condition_matches
    step1 = OnRamp::Step.new(:choose, title: "Choose", branches: [
      {to: :inventory, if: ->(ctx) { ctx[:path] == "inventory" }}
    ])
    step2 = OnRamp::Step.new(:default_next, title: "Default")
    step3 = OnRamp::Step.new(:inventory, title: "Inventory")
    flow = OnRamp::Flow.new(:default, steps: [step1, step2, step3])

    result = flow.next_step(:choose, {path: "inventory"})

    assert_equal step3, result
  end

  def test_executes_on_complete_callback
    result = []
    callback = ->(ctx) { result << ctx[:finished] }
    flow = OnRamp::Flow.new(:default, on_complete: callback)

    flow.run_on_complete({finished: true})

    assert_equal [true], result
  end

  def test_run_on_complete_does_nothing_when_no_callback_defined
    flow = OnRamp::Flow.new(:default)

    assert_nil flow.run_on_complete({})
  end
end
