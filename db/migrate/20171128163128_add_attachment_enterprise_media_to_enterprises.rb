class AddAttachmentEnterpriseMediaToEnterprises < ActiveRecord::Migration[5.1]
  def self.up
    change_table :enterprises do |t|
      t.attachment :sponsor_media
    end
  end

  def self.down
    remove_attachment :enterprises, :sponsor_media
  end
end
