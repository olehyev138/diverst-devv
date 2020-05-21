class AddAnswerCommentsCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :answer_comments_count, :integer
  end
end
