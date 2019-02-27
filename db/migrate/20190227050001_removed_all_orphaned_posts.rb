class RemovedAllOrphanedPosts < ActiveRecord::Migration
  def change
  	SocialLink.includes(:news_feed_link).where(:news_feed_links => {id: nil}).destroy_all
  	NewsLink.includes(:news_feed_link).where(:news_feed_links => {id: nil}).destroy_all
  	GroupMessage.includes(:news_feed_link).where(:news_feed_links => {id: nil}).destroy_all
  end
end
