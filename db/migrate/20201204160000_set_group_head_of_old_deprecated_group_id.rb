class SetGroupHeadOfOldDeprecatedGroupId < ActiveRecord::Migration[5.2]
  def up
    AnnualBudget.column_reload!
    AnnualBudget.where.not(deprecated_group_id: nil).find_each do |ab| 
      ab.update(budget_head_type: 'Group', budget_head_id: ab.deprecated_group_id)
    end
  end

  def down
  end
end
