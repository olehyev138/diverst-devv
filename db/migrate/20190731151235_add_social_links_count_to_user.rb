class AddSocialLinksCountToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :social_links_count, :integer
  end
end
