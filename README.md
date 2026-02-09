# OnRamp

[![CI](https://github.com/tylercschneider/on_ramp/actions/workflows/ci.yml/badge.svg)](https://github.com/tylercschneider/on_ramp/actions/workflows/ci.yml)

A flexible onboarding engine for Rails applications. OnRamp provides a DSL for defining multi-step onboarding flows with conditional branching, progress tracking, and callbacks.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "on_ramp"
```

Then run:

```bash
bundle install
rails generate on_ramp:install
rails db:migrate
```

## Usage

### Configuration

```ruby
# config/initializers/on_ramp.rb
OnRamp.configure do |config|
  config.flows_path = Rails.root.join("app/onboarding/flows")
  config.progress_class = "OnboardingProgress"  # or use default "OnRamp::Progress"
end

# Load flows on app boot
Rails.application.config.to_prepare do
  OnRamp::Registry.reset!
  Dir[Rails.root.join(OnRamp.config.flows_path, "**/*.rb")].each { |f| load(f) }
end
```

### Defining Flows

```ruby
# app/onboarding/flows/default_flow.rb
OnRamp::Registry.register_flow(:default) do
  description "Main onboarding flow"

  step :welcome do
    title "Welcome!"
    component "onboarding/steps/welcome"
  end

  step :choose_path do
    title "Choose Your Path"
    component "onboarding/steps/choose_path"

    branches_to :inventory, if: ->(ctx) { ctx[:chosen_path] == "inventory" }
    branches_to :goals, if: ->(ctx) { ctx[:chosen_path] == "goals" }
  end

  step :inventory do
    title "Inventory Setup"
    component "onboarding/steps/inventory"
    show_if ->(ctx) { ctx[:chosen_path] == "inventory" }
  end

  step :goals do
    title "Goals Setup"
    component "onboarding/steps/goals"
    show_if ->(ctx) { ctx[:chosen_path] == "goals" }
  end

  step :complete do
    title "All Done!"
    component "onboarding/steps/complete"
  end

  on_complete do |context|
    # App-specific completion logic
    context[:account].activate_areas!
  end
end
```

### Making a Model OnRampable

```ruby
class Account < ApplicationRecord
  include OnRamp::OnRampable
end
```

### Using in Controllers

```ruby
class OnboardingController < ApplicationController
  def show
    @progress = current_account.onboarding_progress(:default)
    redirect_to root_path if @progress&.completed?

    flow = OnRamp::Registry[:default]
    @step = flow.find_step(@progress.current_step.to_sym)
  end

  def update
    @progress = current_account.onboarding_progress(:default)
    flow = OnRamp::Registry[:default]
    current_step = flow.find_step(@progress.current_step.to_sym)

    # Run step callback
    context = { account: current_account, progress: @progress }
    current_step.run_after_complete(context, params[:step_data])

    # Mark step complete and advance
    @progress.mark_step_completed(current_step.name, params[:step_data])

    next_step = flow.next_step(current_step.name, context)

    if next_step
      @progress.update!(current_step: next_step.name.to_s)
      redirect_to onboarding_path
    else
      flow.run_on_complete(context)
      @progress.mark_completed!
      redirect_to dashboard_path
    end
  end
end
```

## API Reference

### Step DSL

- `title "Step Title"` - Display title for the step
- `component "path/to/component"` - View component to render
- `show_if ->(ctx) { condition }` - Conditional visibility
- `branches_to :step_name, if: ->(ctx) { condition }` - Conditional next step
- `after_complete { |ctx, data| }` - Callback after step completion

### Flow DSL

- `description "Flow description"` - Human-readable description
- `step :name { }` - Define a step
- `on_complete { |ctx| }` - Callback when flow completes

### OnRampable Methods

- `start_onboarding!(flow_name)` - Start onboarding, returns progress record
- `onboarding_progress(flow_name)` - Get current progress for a flow
- `onboarding_complete?(flow_name)` - Check if flow is completed
- `needs_onboarding?(flow_name)` - Check if onboarding is needed

### Progress Model

- `completed?` - Is the flow finished?
- `skipped?` - Was the flow skipped?
- `in_progress?` - Is the flow actively being completed?
- `mark_step_completed(step_name, data = {})` - Record step completion
- `mark_completed!` - Mark entire flow as completed
- `mark_skipped!` - Mark flow as skipped

## Generators

### Install Generator

```bash
rails generate on_ramp:install
```

Creates migration and initializer.

### Flow Generator

```bash
rails generate on_ramp:flow my_flow
```

Creates a new flow definition file.

## License

MIT License
