class ChangeSocialLinkUrlToLongString < ActiveRecord::Migration
  def up
    change_column :social_network_posts, :url, :text
  end
  def down
    # This might cause trouble if you have strings longer
    # than 191 characters.
    change_column :social_network_posts, :url, :string
  end
end
