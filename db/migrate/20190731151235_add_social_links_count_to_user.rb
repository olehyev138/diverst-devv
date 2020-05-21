class AddSocialLinksCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :social_links_count, :integer
  end
end
