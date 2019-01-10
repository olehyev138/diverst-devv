class AddStatusToMentorshipSessions < ActiveRecord::Migration
  def change
    add_column :mentorship_sessions, :status, :string, :null => false, :default => "pending"
  end
end
