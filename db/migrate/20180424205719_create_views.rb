class CreateViews < ActiveRecord::Migration
  def change
    create_table :views do |t|
      t.integer :user_id, null: false
      t.integer :group_message_id
      t.integer :news_link_id
      t.integer :social_link_id

      t.integer :view_count, null: false, default: 0

      t.timestamps null: false
    end
  end
end
