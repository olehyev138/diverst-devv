class CsvFile < ActiveRecord::Base
  self.table_name = 'csvfiles'

  belongs_to :user
  belongs_to :group

  has_attached_file :import_file, s3_permissions: "private"
  do_not_validate_attachment_file_type :import_file

  after_commit :schedule_users_import, on: :create

  def path_for_csv
    if File.exists?(self.import_file.path)
      self.import_file.path
    else
      Paperclip.io_adapters.for(self.import_file).path
    end
  end

  protected

  def schedule_users_import
    if group_id
      GroupMemberImportCSVJob.perform_later(self.id)
    else
      ImportCSVJob.perform_later(self.id)
    end
  end
end
