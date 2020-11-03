class RemoveNotNullRestrictionOnViewsUser < ActiveRecord::Migration[5.2]
  def change
    change_column :views, :user_id, :bigint, :null => true
  end
end
