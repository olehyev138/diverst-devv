class AddParticipationScoreToGroups < ActiveRecord::Migration[5.1]
  def change
    change_table :groups do |t|
      t.integer :participation_score_7days
    end
  end
end
