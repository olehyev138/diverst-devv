class CreateViews < ActiveRecord::Migration
  def change
    create_table :views do |t|
      t.integer :user_id, null: false
      t.integer :news_feed_link_id, null: false
      t.integer :enterprise_id
      t.integer :view_count, null: false, default: 0

      t.timestamps null: false
    end
  end
end
