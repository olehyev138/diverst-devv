class AddSolvingToQuestions < ActiveRecord::Migration[5.1]
  def change
    change_table :questions do |t|
      t.datetime :solved_at
      t.text :conclusion
    end
  end
end
