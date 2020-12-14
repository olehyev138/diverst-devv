class RemoveNotNullRestrictionOnViewsUser < ActiveRecord::Migration[5.2]
  def up
    change_column :views, :user_id, :bigint, null: true
  end

  def down
    View.where(user_id: nil).destroy_all
    change_column :views, :user_id, :bigint, null: false
  end
end
