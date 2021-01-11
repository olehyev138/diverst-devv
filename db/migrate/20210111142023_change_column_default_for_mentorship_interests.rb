class ChangeColumnDefaultForMentorshipInterests < ActiveRecord::Migration
  def change
    change_column_null :mentorship_interests, :mentoring_interest_id, true
    change_column_null :mentorship_interests, :mentee_interest_id, true
  end
end
