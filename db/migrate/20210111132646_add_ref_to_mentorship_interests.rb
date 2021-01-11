class AddRefToMentorshipInterests < ActiveRecord::Migration
  def change
    add_reference :mentorship_interests, :mentee_interest, index: true, foreign_key: true
  end
end
