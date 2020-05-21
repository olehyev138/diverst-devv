class RemoveColummnsReferencingEvents < ActiveRecord::Migration
  def change
    remove_column :policy_groups, :events_index, :boolean
    remove_column :policy_groups, :events_create, :boolean
    remove_column :policy_groups, :events_manage, :boolean
    remove_column :policy_group_templates, :events_index, :boolean
    remove_column :policy_group_templates, :events_create, :boolean
    remove_column :policy_group_templates, :events_manage, :boolean
  end
end
