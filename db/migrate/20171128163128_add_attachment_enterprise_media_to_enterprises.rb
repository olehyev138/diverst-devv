class AddAttachmentEnterpriseMediaToEnterprises < ActiveRecord::Migration
  def self.up
    change_table :enterprises do |t|
      t.attachment :sponsor_media
    end
  end

  def self.down
    remove_attachment :enterprises, :sponsor_media
  end
end
