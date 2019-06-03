class CreateNewsFeedLinkSegments < ActiveRecord::Migration[5.1]
    def up
        create_table :news_feed_link_segments do |t|
            t.references    :news_feed_link
            t.references    :segment
            t.references    :link_segment, :polymorphic => true
            t.timestamps    null: false
        end
    end
    
    def down
        drop_table :news_feed_link_segments
    end
end
