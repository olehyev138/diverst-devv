class MentoringSessionsChangeFormatToMedium < ActiveRecord::Migration[5.1]
  def change
    rename_column :mentoring_sessions, :format, :medium
  end
end
