class AddCommentToUserRewards < ActiveRecord::Migration
  def change
    add_column :user_rewards, :comment, :text
  end
end
