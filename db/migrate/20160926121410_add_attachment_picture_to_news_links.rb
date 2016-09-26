class AddAttachmentPictureToNewsLinks < ActiveRecord::Migration
  def self.up
    change_table :news_links do |t|
      t.attachment :picture
    end
  end

  def self.down
    remove_attachment :news_links, :picture
  end
end
