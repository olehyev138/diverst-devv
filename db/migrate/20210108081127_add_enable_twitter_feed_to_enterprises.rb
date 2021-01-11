class AddEnableTwitterFeedToEnterprises < ActiveRecord::Migration[5.2]
  def change
    #
    ## Legacy migration
    #
    unless column_exists? :enterprises, :twitter_feed_enabled
      add_column :enterprises, :twitter_feed_enabled, :boolean, default: false
    end
  end
end
