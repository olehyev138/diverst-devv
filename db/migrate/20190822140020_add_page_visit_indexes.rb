class AddPageVisitIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :page_visitation_data, [:user_id, :page_url]
    add_index :page_visitation_data, [:page_url, :user_id]
    add_index :page_names, [:page_url, :page_name]
    add_index :page_names, [:page_name, :page_url]
  end
end
