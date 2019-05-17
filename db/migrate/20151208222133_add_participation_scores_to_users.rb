class AddParticipationScoresToUsers < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |t|
      t.integer :participation_score_7days, default: 0
    end
  end
end
