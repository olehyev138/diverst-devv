class AddViewsCountToFolders < ActiveRecord::Migration
  def change
    add_column :folders, :views_count, :integer

    Folder.find_each do |folder|
      Folder.reset_counters(folder.id, :views)
    end
  end
end
