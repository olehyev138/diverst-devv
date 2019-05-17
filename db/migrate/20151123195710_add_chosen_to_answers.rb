class AddChosenToAnswers < ActiveRecord::Migration[5.1]
  def change
    change_table :answers do |t|
      t.boolean :chosen
    end
  end
end
