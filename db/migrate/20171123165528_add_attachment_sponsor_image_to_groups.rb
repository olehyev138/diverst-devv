class AddAttachmentSponsorImageToGroups < ActiveRecord::Migration
  def self.up
    change_table :groups do |t|
      t.attachment :sponsor_image
    end
  end

  def self.down
    remove_attachment :groups, :sponsor_image
  end
end
