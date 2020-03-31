class AddAnswerCommentsCountToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :answer_comments_count, :integer
  end
end
