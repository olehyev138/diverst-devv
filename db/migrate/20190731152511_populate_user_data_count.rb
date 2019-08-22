class PopulateUserDataCount < ActiveRecord::Migration
  def up
    User.find_each do |user|
      User.reset_counters(user.id,
                          :initiatives,
                          :own_messages,
                          :social_links,
                          :own_news_links,
                          :answer_comments,
                          :message_comments,
                          :news_link_comments
      )
    end
  end
end
