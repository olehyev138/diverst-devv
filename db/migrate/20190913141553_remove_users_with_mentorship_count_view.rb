class RemoveUsersWithMentorshipCountView < ActiveRecord::Migration
  def change
    drop_view :user_with_mentor_counts, revert_to_version: 1
  end
end
