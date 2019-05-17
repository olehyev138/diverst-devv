class AddGroupIdToSocialLinks < ActiveRecord::Migration[5.1]
    def change
        add_column :social_network_posts, :group_id, :integer, default: nil
    end
end
