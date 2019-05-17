class AddAttachmentPictureToNewsLinks < ActiveRecord::Migration[5.1]
  def self.up
    change_table :news_links do |t|
      t.attachment :picture
    end
  end

  def self.down
    remove_attachment :news_links, :picture
  end
end
