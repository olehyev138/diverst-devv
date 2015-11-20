class CreateAnswerComments < ActiveRecord::Migration
  def change
    create_table :answer_comments do |t|
      t.text :content
      t.belongs_to :author
      t.belongs_to :answer

      t.timestamps null: false
    end
  end
end
