class ChangeInitiativeEstimatedFundingToDecimal < ActiveRecord::Migration
  def up
    change_column :initiatives, :estimated_funding, :decimal, default: 0, precision: 8, scale: 2
  end

  def down
    change_column :initiatives, :estimated_funding, :integer, default: 0
  end
end
