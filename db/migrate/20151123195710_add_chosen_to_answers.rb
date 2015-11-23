class AddChosenToAnswers < ActiveRecord::Migration
  def change
    change_table :answers do |t|
      t.boolean :chosen
    end
  end
end
