class AddAcceptingMentorAndMenteeRequestsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :accepting_mentor_requests, :boolean, default: true
    add_column :users, :accepting_mentee_requests, :boolean, default: true
  end
end
