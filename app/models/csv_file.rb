class CsvFile < BaseClass
  self.table_name = 'csvfiles'

  belongs_to :user
  belongs_to :group

  has_attached_file :import_file, s3_permissions: 'private'
  has_attached_file :download_file, s3_permissions: 'private',
                                    s3_headers: lambda { |attachment|
                                                  {
                                                      'Content-Type' => 'text/csv',
                                                      'Content-Disposition' => 'attachment',
                                                  }
                                                }
  do_not_validate_attachment_file_type :import_file
  do_not_validate_attachment_file_type :download_file

  after_commit :schedule_users_import, on: :create

  scope :download_files, -> { where("download_file_file_name <> ''") }

  def path_for_csv
    if File.exist?(self.import_file.path)
      self.import_file.path
    else
      Paperclip.io_adapters.for(self.import_file).path
    end
  end

  protected

  def schedule_users_import
    return if self.download_file?

    if group_id
      GroupMemberImportCSVJob.perform_later(self.id)
    else
      ImportCSVJob.perform_later(self.id)
    end
  end
end
