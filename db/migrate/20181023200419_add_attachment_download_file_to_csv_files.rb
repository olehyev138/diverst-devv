class AddAttachmentDownloadFileToCsvFiles < ActiveRecord::Migration
  def self.up
    change_table :csvfiles do |t|
      t.attachment :download_file
    end
  end

  def self.down
    remove_attachment :csvfiles, :download_file
  end
end
