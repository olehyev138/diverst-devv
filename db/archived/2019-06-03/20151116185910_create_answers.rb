class CreateAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :answers do |t|
      t.belongs_to :question
      t.belongs_to :author
      t.text :content

      t.timestamps null: false
    end
  end
end
