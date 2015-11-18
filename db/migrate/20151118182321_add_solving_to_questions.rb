class AddSolvingToQuestions < ActiveRecord::Migration
  def change
    change_table :questions do |t|
      t.datetime :solved_at
      t.text :conclusion
    end
  end
end
