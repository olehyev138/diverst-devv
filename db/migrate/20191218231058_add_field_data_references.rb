class AddFieldDataReferences < ActiveRecord::Migration[5.2]
  def change
    add_column :group_updates, :field_data, :bigint
    add_index :group_updates, :field_data

    add_column :initiative_updates, :field_data, :bigint
    add_index :initiative_updates, :field_data

    add_column :poll_responses, :field_data, :bigint
    add_index :poll_responses, :field_data

    add_column :user_groups, :field_data, :bigint
    add_index :user_groups, :field_data
  end
end
