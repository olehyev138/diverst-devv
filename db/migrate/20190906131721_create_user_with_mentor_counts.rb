class CreateUserWithMentorCounts < ActiveRecord::Migration
  def change
    create_view :user_with_mentor_counts
  end
end
