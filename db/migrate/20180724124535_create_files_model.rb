class CreateFilesModel < ActiveRecord::Migration
  def change
    create_table :csvfiles do |t|
      t.attachment :import_file
    end
  end
end
