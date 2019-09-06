class CreateUserMentorPairs < ActiveRecord::Migration
  def change
    create_view :user_mentor_pairs
  end
end
