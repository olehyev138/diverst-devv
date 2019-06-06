class AddAttachmentSponsorMediaToSponsors < ActiveRecord::Migration[5.1]
  def self.up
    change_table :sponsors do |t|
      t.attachment :sponsor_media
    end
  end

  def self.down
    remove_attachment :sponsors, :sponsor_media
  end
end
