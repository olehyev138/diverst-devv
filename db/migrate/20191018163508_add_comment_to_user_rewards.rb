class AddCommentToUserRewards < ActiveRecord::Migration[5.2]
  def change
    add_column :user_rewards, :comment, :text
  end
end
