require 'test_helper'

module OnRamp
  module Dsl
    class StepBuilderTest < OnRamp::TestCase
      def test_builds_step_with_title
        step = OnRamp::Dsl::StepBuilder.build(:welcome) do
          title 'Welcome!'
        end

        assert_equal :welcome, step.name
        assert_equal 'Welcome!', step.title
      end

      def test_builds_step_with_component
        step = OnRamp::Dsl::StepBuilder.build(:welcome) do
          title 'Welcome!'
          component 'onboarding/steps/welcome'
        end

        assert_equal 'onboarding/steps/welcome', step.component
      end

      def test_builds_step_with_show_if_condition
        step = OnRamp::Dsl::StepBuilder.build(:inventory) do
          title 'Inventory'
          show_if ->(ctx) { ctx[:path] == 'inventory' }
        end

        assert step.visible?(path: 'inventory')
        refute step.visible?(path: 'goals')
      end

      def test_builds_step_with_branches_to
        step = OnRamp::Dsl::StepBuilder.build(:choose) do
          title 'Choose'
          branches_to :inventory, if: ->(ctx) { ctx[:path] == 'inventory' }
          branches_to :goals, if: ->(ctx) { ctx[:path] == 'goals' }
        end

        assert_equal :inventory, step.next_step_name(path: 'inventory')
        assert_equal :goals, step.next_step_name(path: 'goals')
      end

      def test_builds_step_with_after_complete_callback
        result = []
        step = OnRamp::Dsl::StepBuilder.build(:welcome) do
          title 'Welcome!'
          after_complete { |_ctx, data| result << data }
        end

        step.run_after_complete({}, { submitted: true })

        assert_equal [{ submitted: true }], result
      end
    end
  end
end
