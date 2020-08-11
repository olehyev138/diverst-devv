class AddAttachmentVideoUploadToAnswers < ActiveRecord::Migration
  def self.up
    change_table :answers do |t|
      t.attachment :video_upload
    end
  end

  def self.down
    remove_attachment :answers, :video_upload
  end
end
