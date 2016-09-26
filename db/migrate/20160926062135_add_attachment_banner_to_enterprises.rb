class AddAttachmentBannerToEnterprises < ActiveRecord::Migration
  def self.up
    change_table :enterprises do |t|
      t.attachment :banner
    end
  end

  def self.down
    remove_attachment :enterprises, :banner
  end
end
