class AddDownloadFileNameToCsvFiles < ActiveRecord::Migration[5.1]
  def change
    add_column :csvfiles, :download_file_name, :string
  end
end
