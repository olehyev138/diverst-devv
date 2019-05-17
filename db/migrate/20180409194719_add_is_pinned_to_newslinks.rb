class AddIsPinnedToNewslinks < ActiveRecord::Migration[5.1]
  def change
    add_column :news_feed_links,
                :is_pinned,
                :boolean,
                default: false
  end
end
