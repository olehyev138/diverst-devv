class UpdateMentorshipAvailabilityFields < ActiveRecord::Migration
  def change
    # we delete existing availabilities because the model is storing data differently
    MentorshipAvailability.destroy_all

    add_column :mentorship_availabilities, :day, :string, :default => "monday", :null => false
    
    change_column :mentorship_availabilities, :start, :string
    change_column :mentorship_availabilities, :end,   :string
  end
end
