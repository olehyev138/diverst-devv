class AddEnterpriseIdToGroupCategoryTypesTable < ActiveRecord::Migration
  def change
    add_column :group_category_types, :enterprise_id, :integer, default: nil
    add_column :group_categories, :enterprise_id, :integer, default: nil
  end
end
