class RemoveAttendingFromMentorshipSessions < ActiveRecord::Migration
  def change
    remove_column :mentorship_sessions, :attending, :boolean
  end
end
