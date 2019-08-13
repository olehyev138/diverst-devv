class PopulateUserOwnNewsLinksCount < ActiveRecord::Migration
  def up
    User.find_each do |user|
      User.reset_counters(user.id, :own_news_links)
    end
  end
end
