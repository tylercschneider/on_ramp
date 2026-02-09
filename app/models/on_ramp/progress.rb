module OnRamp
  class Progress < ApplicationRecord
    self.table_name = "on_ramp_progresses"

    belongs_to :progressable, polymorphic: true

    validates :flow_name, presence: true

    def completed?
      completed_at.present?
    end

    def skipped?
      skipped_at.present?
    end

    def in_progress?
      started_at.present? && !completed? && !skipped?
    end

    def mark_step_completed(step_name, data = {})
      completed_steps << step_name.to_s unless completed_steps.include?(step_name.to_s)
      step_data[step_name.to_s] = data if data.present?
    end

    def mark_completed!
      update!(completed_at: Time.current)
    end

    def mark_skipped!
      update!(skipped_at: Time.current)
    end

    def chosen_path
      metadata["chosen_path"]
    end
  end
end
