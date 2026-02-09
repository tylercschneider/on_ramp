module OnRamp
  class Step
    attr_reader :name, :title, :component, :show_if, :branches, :after_complete

    def initialize(name, title:, component: nil, show_if: nil, branches: [], after_complete: nil)
      @name = name
      @title = title
      @component = component
      @show_if = show_if
      @branches = branches
      @after_complete = after_complete
    end

    def visible?(context)
      return true unless show_if
      show_if.call(context)
    end

    def next_step_name(context)
      return nil if branches.empty?
      branch = branches.find { |b| b[:if].call(context) }
      branch&.dig(:to)
    end

    def run_after_complete(context, data)
      after_complete&.call(context, data)
    end
  end
end
