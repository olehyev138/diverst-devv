class CreateJoinTableNewsFeedLinksNewsTags < ActiveRecord::Migration
  def change
    create_join_table :news_feed_links, :news_tags do |t|
      t.index [:news_feed_link_id, :news_tag_id]
      t.index [:news_tag_id, :news_feed_link_id]
    end
  end
end
