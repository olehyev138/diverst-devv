class AddEnableTwitterFeedToEnterprises < ActiveRecord::Migration
  def change
    add_column :enterprises, :twitter_feed_enabled, :boolean, default: false
  end
end
