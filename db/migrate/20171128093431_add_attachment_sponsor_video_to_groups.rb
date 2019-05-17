class AddAttachmentSponsorVideoToGroups < ActiveRecord::Migration[5.1]
  def self.up
    change_table :groups do |t|
      t.attachment :sponsor_media
    end
  end

  def self.down
    remove_attachment :groups, :sponsor_media
  end
end
