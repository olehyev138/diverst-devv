class AddUrlToSocialMediaPosts < ActiveRecord::Migration
  def change
    change_table :social_network_posts do |t|
      t.string :url, null: false
    end
  end
end
