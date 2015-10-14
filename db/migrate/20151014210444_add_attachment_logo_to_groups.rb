class AddAttachmentLogoToGroups < ActiveRecord::Migration
  def self.up
    change_table :groups do |t|
      t.attachment :logo
    end
  end

  def self.down
    remove_attachment :groups, :logo
  end
end
