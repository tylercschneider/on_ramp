require 'test_helper'

module OnRamp
  class StepTest < OnRamp::TestCase
    def test_initializes_with_name_and_title
      step = OnRamp::Step.new(:welcome, title: 'Welcome!')

      assert_equal :welcome, step.name
      assert_equal 'Welcome!', step.title
    end

    def test_stores_component_path
      step = OnRamp::Step.new(:welcome, title: 'Welcome!', component: 'onboarding/steps/welcome')

      assert_equal 'onboarding/steps/welcome', step.component
    end

    def test_evaluates_show_if_condition
      step = OnRamp::Step.new(:inventory_intro, title: 'Inventory', show_if: ->(ctx) { ctx[:path] == 'inventory' })

      assert step.visible?(path: 'inventory')
      refute step.visible?(path: 'goals')
    end

    def test_visible_returns_true_when_no_show_if_defined
      step = OnRamp::Step.new(:welcome, title: 'Welcome!')

      assert step.visible?({})
    end

    def test_determines_next_step_via_branches
      branches = [
        { to: :inventory_intro, if: ->(ctx) { ctx[:path] == 'inventory' } },
        { to: :goals_intro, if: ->(ctx) { ctx[:path] == 'goals' } }
      ]
      step = OnRamp::Step.new(:choose_path, title: 'Choose', branches: branches)

      assert_equal :inventory_intro, step.next_step_name(path: 'inventory')
      assert_equal :goals_intro, step.next_step_name(path: 'goals')
    end

    def test_next_step_name_returns_nil_when_no_branch_matches
      branches = [
        { to: :inventory_intro, if: ->(ctx) { ctx[:path] == 'inventory' } }
      ]
      step = OnRamp::Step.new(:choose_path, title: 'Choose', branches: branches)

      assert_nil step.next_step_name(path: 'other')
    end

    def test_next_step_name_returns_nil_when_no_branches_defined
      step = OnRamp::Step.new(:welcome, title: 'Welcome!')

      assert_nil step.next_step_name({})
    end

    def test_executes_after_complete_callback
      result = []
      callback = ->(ctx, data) { result << { ctx: ctx, data: data } }
      step = OnRamp::Step.new(:welcome, title: 'Welcome!', after_complete: callback)

      step.run_after_complete({ foo: 'bar' }, { input: 'value' })

      assert_equal 1, result.size
      assert_equal({ foo: 'bar' }, result.first[:ctx])
      assert_equal({ input: 'value' }, result.first[:data])
    end

    def test_run_after_complete_does_nothing_when_no_callback_defined
      step = OnRamp::Step.new(:welcome, title: 'Welcome!')

      assert_nil step.run_after_complete({}, {})
    end
  end
end
