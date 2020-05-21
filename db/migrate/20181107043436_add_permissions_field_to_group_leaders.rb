class AddPermissionsFieldToGroupLeaders < ActiveRecord::Migration
  def change
    add_column  :group_leaders, :budget_approval,       :boolean, :default => false
    add_column  :group_leaders, :groups_budgets_manage, :boolean, :default => false
    add_column  :group_leaders, :manage_posts,          :boolean, :default => false
    add_column  :group_leaders, :initiatives_index,     :boolean, :default => false
  end
end
