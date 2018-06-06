class CreateNewsFeedLikes < ActiveRecord::Migration
  def change
    create_table :news_feed_likes do |t|
      t.references :news_feed_link, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
