class PopulateUserOwnMessagesCount < ActiveRecord::Migration
  def up
    User.find_each do |user|
      User.reset_counters(user.id, :own_messages)
    end
  end
end
