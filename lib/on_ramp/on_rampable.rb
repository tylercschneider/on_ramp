require 'on_ramp/registry'

module OnRamp
  module OnRampable
    extend ActiveSupport::Concern

    included do
      has_many OnRamp.config.association_name,
               class_name: OnRamp.config.progress_class,
               as: :progressable,
               dependent: :destroy
    end

    def start_onboarding!(flow_name)
      flow = Registry.find(flow_name)
      raise ArgumentError, "Flow '#{flow_name}' not found" unless flow

      first_step = flow.first_step

      send(OnRamp.config.association_name).create!(
        flow_name: flow_name.to_s,
        current_step: first_step&.name&.to_s,
        started_at: Time.current
      )
    end

    def onboarding_progress(flow_name)
      send(OnRamp.config.association_name).find_by(flow_name: flow_name.to_s)
    end

    def onboarding_complete?(flow_name)
      onboarding_progress(flow_name)&.completed? || false
    end

    def needs_onboarding?(flow_name)
      progress = onboarding_progress(flow_name)
      return true unless progress

      !progress.completed? && !progress.skipped?
    end
  end
end
