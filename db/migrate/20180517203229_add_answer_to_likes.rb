class AddAnswerToLikes < ActiveRecord::Migration
  def change
    add_reference :likes, :answer, index: true, foreign_key: true
  end
end
