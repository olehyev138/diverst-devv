class AddAutoArchiveManageAttributeToPolicyGroups < ActiveRecord::Migration
  def change
  add_column :policy_group_templates, :auto_archive_manage, :boolean, default: false
  add_column :policy_groups, :auto_archive_manage, :boolean, default: false
  end
end
