class AddParticipationScoresToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :participation_score_7days, default: 0
    end
  end
end
