class AddMentorshipCountToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :mentors_count, :integer
    add_column :users, :mentees_count, :integer
  end
end
