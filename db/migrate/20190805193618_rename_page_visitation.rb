class RenamePageVisitation < ActiveRecord::Migration
  def change
    rename_table :page_visitations, :page_visitation_data
  end
end
