class CreateNewsFeeds < ActiveRecord::Migration
    def change
        create_table :news_feeds do |t|
            t.references :group
            t.timestamps :null => false
        end
    end
end
