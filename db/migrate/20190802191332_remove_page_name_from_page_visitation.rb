class RemovePageNameFromPageVisitation < ActiveRecord::Migration[5.2]
  def change
    remove_column :page_visitations, :page_name, :string
    rename_column :page_visitations, :page_site, :page_url
  end
end
