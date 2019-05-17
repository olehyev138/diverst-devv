class CreateFilesModel < ActiveRecord::Migration[5.1]
  def change
    create_table :csvfiles do |t|
      t.attachment :import_file
    end
  end
end
