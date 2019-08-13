class PopulateUserNewsLinkCommentsCount < ActiveRecord::Migration
  def up
    User.find_each do |user|
      User.reset_counters(user.id, :news_link_comments)
    end
  end
end
