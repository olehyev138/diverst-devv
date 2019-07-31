class PopulateUserMessageCommentsCount < ActiveRecord::Migration
  def up
    User.find_each do |user|
      User.reset_counters(user.id, :message_comments)
    end
  end
end
