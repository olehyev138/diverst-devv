class AddParticipationScoreToGroups < ActiveRecord::Migration
  def change
    change_table :groups do |t|
      t.integer :participation_score_7days
    end
  end
end
