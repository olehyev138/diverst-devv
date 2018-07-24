class CsvFile < ActiveRecord::Base
  self.table_name = 'csvfiles'

  belongs_to :user

  has_attached_file :import_file, s3_permissions: "private"
  do_not_validate_attachment_file_type :import_file

  after_create :schedule_users_import

  def path_for_csv
    File.exists?(self.import_file.path) ?
                    self.import_file.path :
                    self.import_file.expiring_url(3600000)
  end

  protected

  def schedule_users_import
    ImportCSVJob.perform_later(self.id)
  end
end
