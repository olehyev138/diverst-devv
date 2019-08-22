class PopulateUserDataCount < ActiveRecord::Migration
  def up
    User.pluck(:id).each do |user_id|
      User.reset_counters(user_id,
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
