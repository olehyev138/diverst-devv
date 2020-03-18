class CreateUserWithMentorCounts < ActiveRecord::Migration[5.2]
  def change
    create_view :user_with_mentor_counts
  end
end
