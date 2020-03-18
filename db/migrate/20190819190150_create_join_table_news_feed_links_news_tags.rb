class CreateJoinTableNewsFeedLinksNewsTags < ActiveRecord::Migration[5.2]
  # def change
  #   create_join_table :news_feed_links, :news_tags do |t|
  #     t.index [:news_feed_link_id, :news_tag_id]
  #     t.index [:news_tag_id, :news_feed_link_id]
  #   end
  # end

  def change
    create_table :news_feed_link_tags, id: false do |t|
      t.integer :news_feed_link_id
      t.string :news_tag_name
      t.index [:news_feed_link_id, :news_tag_name]
      t.index [:news_tag_name, :news_feed_link_id]
    end
  end
end
