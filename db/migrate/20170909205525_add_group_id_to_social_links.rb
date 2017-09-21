class AddGroupIdToSocialLinks < ActiveRecord::Migration
    def change
        add_column :social_network_posts, :group_id, :integer, default: nil
    end
end
