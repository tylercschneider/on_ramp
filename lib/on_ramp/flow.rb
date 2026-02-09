module OnRamp
  class Flow
    attr_reader :name, :description, :steps, :on_complete

    def initialize(name, description: nil, steps: [], on_complete: nil)
      @name = name
      @description = description
      @steps = steps
      @on_complete = on_complete
    end

    def find_step(step_name)
      steps.find { |s| s.name == step_name }
    end

    def first_step
      steps.first
    end

    def next_step(current_step_name, context)
      current = find_step(current_step_name)
      return nil unless current

      # Check for conditional branching first
      branched_name = current.next_step_name(context)
      return find_step(branched_name) if branched_name

      # Fall back to sequential order
      current_index = steps.index(current)
      steps[current_index + 1]
    end

    def run_on_complete(context)
      on_complete&.call(context)
    end
  end
end
