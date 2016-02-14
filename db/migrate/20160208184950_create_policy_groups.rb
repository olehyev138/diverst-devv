class CreatePolicyGroups < ActiveRecord::Migration
  def change
    create_table :policy_groups do |t|
      t.string :name
      t.belongs_to :enterprise

      t.boolean :campaigns_index
      t.boolean :campaigns_create
      t.boolean :campaigns_manage

      t.boolean :polls_index
      t.boolean :polls_create
      t.boolean :polls_manage

      t.boolean :events_index
      t.boolean :events_create
      t.boolean :events_manage

      t.boolean :group_messages_index
      t.boolean :group_messages_create
      t.boolean :group_messages_manage

      t.boolean :groups_index
      t.boolean :groups_create
      t.boolean :groups_manage
      t.boolean :groups_members_index
      t.boolean :groups_members_manage

      t.boolean :metrics_dashboards_index
      t.boolean :metrics_dashboards_create

      t.boolean :news_links_index
      t.boolean :news_links_create
      t.boolean :news_links_manage

      t.boolean :enterprise_resources_index
      t.boolean :enterprise_resources_create
      t.boolean :enterprise_resources_manage

      t.boolean :segments_index
      t.boolean :segments_create
      t.boolean :segments_manage

      t.boolean :users_index
      t.boolean :users_manage

      t.boolean :global_settings_manage

      t.timestamps null: false
    end
  end
end
