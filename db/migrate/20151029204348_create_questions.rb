class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title
      t.text :description

      t.belongs_to :campaign

      t.timestamps null: false
    end
  end
end
