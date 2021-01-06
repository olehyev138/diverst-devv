class AllowEstimatedFundingToBeNull < ActiveRecord::Migration[5.2]
  def up
    change_column :initiatives, :estimated_funding, :integer, null: true
  end

  def down
    change_column :initiatives, :estimated_funding, :integer, null: false
  end
end
