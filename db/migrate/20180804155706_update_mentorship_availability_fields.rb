class UpdateMentorshipAvailabilityFields < ActiveRecord::Migration
  def up
    # we delete existing availabilities because the model is storing data differently
    MentorshipAvailability.destroy_all
    
    add_column :mentoring_requests, :mentoring_type, :string, :default => "mentor", :null => false

    add_column :mentorship_availabilities, :day, :string, :default => "monday", :null => false
    
    change_column :mentorship_availabilities, :start, :string
    change_column :mentorship_availabilities, :end,   :string
    
    add_column :groups, :default_mentor_group, :boolean, :default => false
  end

  def down
    remove_column :mentoring_requests, :mentoring_type, :string
    
    MentorshipAvailability.update_all(:start => Date.today)
    MentorshipAvailability.update_all(:end => Date.today)
    
    remove_column :mentorship_availabilities, :day, :string
    remove_column :groups, :default_mentor_group, :boolean
    
    change_column :mentorship_availabilities, :start, :datetime
    change_column :mentorship_availabilities, :end,   :datetime
  end
end