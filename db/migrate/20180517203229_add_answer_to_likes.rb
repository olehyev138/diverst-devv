class AddAnswerToLikes < ActiveRecord::Migration[5.1]
  def change
    add_reference :likes, :answer, index: true, foreign_key: true
  end
end
