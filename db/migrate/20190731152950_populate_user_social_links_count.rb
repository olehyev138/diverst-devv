class PopulateUserSocialLinksCount < ActiveRecord::Migration
  def up
    User.find_each do |user|
      User.reset_counters(user.id, :social_links)
    end
  end
end
