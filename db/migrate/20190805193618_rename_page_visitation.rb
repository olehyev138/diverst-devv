class RenamePageVisitation < ActiveRecord::Migration[5.2]
  def change
    rename_table :page_visitations, :page_visitation_data
  end
end
