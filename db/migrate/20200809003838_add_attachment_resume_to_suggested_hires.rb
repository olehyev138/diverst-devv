class AddAttachmentResumeToSuggestedHires < ActiveRecord::Migration
  def self.up
    change_table :suggested_hires do |t|
      t.attachment :resume
    end
  end

  def self.down
    remove_attachment :suggested_hires, :resume
  end
end
