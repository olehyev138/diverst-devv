class CreateShareLinks < ActiveRecord::Migration
  def change
    create_table :share_links do |t|
      t.integer :news_feed_id, null: false
      t.integer :news_feed_link_id, null: false
      t.boolean :approved, null: false, default: false

      t.timestamps null: false
    end
  end
end
