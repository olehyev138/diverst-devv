class AddUniqueIndexForAnswerToLikes < ActiveRecord::Migration
  def change
    add_index :likes, [:user_id, :answer_id, :enterprise_id], unique: true
  end
end
