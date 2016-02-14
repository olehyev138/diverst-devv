class CreatePolicyGroups < ActiveRecord::Migration
  def change
    create_table :policy_groups do |t|
      t.string :name
      t.belongs_to :enterprise

      t.boolean :campaigns_index, default: false
      t.boolean :campaigns_create, default: false
      t.boolean :campaigns_manage, default: false

      t.boolean :polls_index, default: false
      t.boolean :polls_create, default: false
      t.boolean :polls_manage, default: false

      t.boolean :events_index, default: false
      t.boolean :events_create, default: false
      t.boolean :events_manage, default: false

      t.boolean :group_messages_index, default: false
      t.boolean :group_messages_create, default: false
      t.boolean :group_messages_manage, default: false

      t.boolean :groups_index, default: false
      t.boolean :groups_create, default: false
      t.boolean :groups_manage, default: false
      t.boolean :groups_members_index, default: false
      t.boolean :groups_members_manage, default: false

      t.boolean :metrics_dashboards_index, default: false
      t.boolean :metrics_dashboards_create, default: false

      t.boolean :news_links_index, default: false
      t.boolean :news_links_create, default: false
      t.boolean :news_links_manage, default: false

      t.boolean :enterprise_resources_index, default: false
      t.boolean :enterprise_resources_create, default: false
      t.boolean :enterprise_resources_manage, default: false

      t.boolean :segments_index, default: false
      t.boolean :segments_create, default: false
      t.boolean :segments_manage, default: false

      t.boolean :users_index, default: false
      t.boolean :users_manage, default: false

      t.boolean :global_settings_manage, default: false

      t.timestamps null: false
    end
  end
end
