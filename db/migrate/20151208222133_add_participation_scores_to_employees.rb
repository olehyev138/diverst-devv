class AddParticipationScoresToEmployees < ActiveRecord::Migration
  def change
    change_table :employees do |t|
      t.integer :participation_score_7days, default: 0
    end
  end
end
