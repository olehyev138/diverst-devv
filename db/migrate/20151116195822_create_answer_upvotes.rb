class CreateAnswerUpvotes < ActiveRecord::Migration
  def change
    create_table :answer_upvotes do |t|
      t.belongs_to :author
      t.belongs_to :answer

      t.timestamps null: false
    end
  end
end
