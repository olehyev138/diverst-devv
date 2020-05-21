class AddDownloadFileNameToCsvFiles < ActiveRecord::Migration
  def change
    add_column :csvfiles, :download_file_name, :string
  end
end
