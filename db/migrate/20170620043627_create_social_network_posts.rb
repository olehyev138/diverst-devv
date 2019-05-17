class CreateSocialNetworkPosts < ActiveRecord::Migration[5.1]
  def change
    create_table :social_network_posts do |t|
      t.integer :author_id
      t.text :embed_code
      t.timestamps null: false
    end
  end
end
