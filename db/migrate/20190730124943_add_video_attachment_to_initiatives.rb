class AddVideoAttachmentToInitiatives < ActiveRecord::Migration[5.2]
  def self.up
    change_table :initiatives do |t|
      t.attachment :video
    end
  end

  def self.down
    remove_attachment :initiatives, :video
  end
end
