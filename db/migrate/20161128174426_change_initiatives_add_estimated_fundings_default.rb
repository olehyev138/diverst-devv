class ChangeInitiativesAddEstimatedFundingsDefault < ActiveRecord::Migration
  def change
    change_column :initiatives, :estimated_funding, :integer, default: 0
  end
end
