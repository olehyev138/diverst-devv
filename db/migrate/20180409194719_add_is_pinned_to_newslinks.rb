class AddIsPinnedToNewslinks < ActiveRecord::Migration
  def change
    add_column :news_feed_links,
                :is_pinned,
                :boolean,
                default: false
  end
end
