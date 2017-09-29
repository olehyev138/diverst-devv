class ConvertDatabaseToUtf8mb4 < ActiveRecord::Migration
    #http://blog.arkency.com/2015/05/how-to-store-emoji-in-a-rails-app-with-a-mysql-database/
    def change
        # for each table that will store unicode execute:
        execute "ALTER TABLE social_network_posts CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
        # for each string/text column with unicode content execute:
        execute "ALTER TABLE social_network_posts CHANGE embed_code embed_code TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    end
end