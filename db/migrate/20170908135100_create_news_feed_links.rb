class CreateNewsFeedLinks < ActiveRecord::Migration
    def change
        create_table :news_feed_links do |t|
            t.references    :news_feed
            t.boolean       :approved, :default => false
            t.references    :link, :polymorphic => true
            t.timestamps    :null => false
        end
    end
end
