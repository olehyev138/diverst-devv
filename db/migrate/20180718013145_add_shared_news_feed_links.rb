class AddSharedNewsFeedLinks < ActiveRecord::Migration
  def change
    create_table :shared_news_feed_links do |t|
      t.references    :news_feed_link,    :null => false
      t.references    :news_feed,          :null => false
      t.timestamps
    end
    
    Group.reset_column_information
    
    Group.includes(:news_feed).where(:news_feeds => {:id => nil}).find_each do |group|
      group.create_news_feed
    end
  end
end
