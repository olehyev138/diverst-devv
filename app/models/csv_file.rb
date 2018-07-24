class CsvFile < ActiveRecord::Base
  self.table_name = 'csvfiles'

  belongs_to :user

  has_attached_file :import_file, s3_permissions: "private"
  validates_attachment_content_type :import_file, content_type: %r{\Atext\/.*\Z}

  after_create :schedule_users_import

  protected

  def schedule_users_import
    ImportCSVJob.perform_later(self.id)
  end
end
