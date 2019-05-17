class AddUrlToSocialMediaPosts < ActiveRecord::Migration[5.1]
  def change
    change_table :social_network_posts do |t|
      t.string :url, null: false
    end
  end
end
