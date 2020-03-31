class RemovedAllOrphanedPosts < ActiveRecord::Migration[5.1]
  def change
    # If this is not reset then it tries to access non-existant columns when joining the models below
    NewsFeedLink.column_reload!
    SocialLink.column_reload!
    NewsLink.column_reload!
    GroupMessage.column_reload!

  	SocialLink.includes(:news_feed_link).where(:news_feed_links => {id: nil}).destroy_all
  	NewsLink.includes(:news_feed_link).where(:news_feed_links => {id: nil}).destroy_all
  	GroupMessage.includes(:news_feed_link).where(:news_feed_links => {id: nil}).destroy_all
  end
end
