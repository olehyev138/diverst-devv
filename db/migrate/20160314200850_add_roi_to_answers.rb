class AddRoiToAnswers < ActiveRecord::Migration
  def change
    change_table :answers do |t|
      t.text :outcome
      t.integer :value
      t.integer :benefit_type
      t.attachment :supporting_document
    end
  end
end
