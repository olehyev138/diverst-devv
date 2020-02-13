class AddMentorshipCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mentors_count, :integer
    add_column :users, :mentees_count, :integer
  end
end
