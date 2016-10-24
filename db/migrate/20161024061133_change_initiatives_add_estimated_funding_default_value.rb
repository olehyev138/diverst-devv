class ChangeInitiativesAddEstimatedFundingDefaultValue < ActiveRecord::Migration
  def up
    change_column_default :initiatives, :estimated_funding, from: nil, to: 0
    change_column_null :initiatives, :estimated_funding, false
  end

  def down
    change_column_default :initiatives, :estimated_funding, from: 0, to: nil
    change_column_null :initiatives, :estimated_funding, true
  end
end
