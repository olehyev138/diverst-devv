class AddAttachmentSupportingDocumentFromSponsorToAnswers < ActiveRecord::Migration
  def self.up
    change_table :answers do |t|
      t.attachment :supporting_document_from_sponsor
    end
  end

  def self.down
    remove_attachment :answers, :supporting_document_from_sponsor
  end
end
