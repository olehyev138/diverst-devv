class CsvFile < ApplicationRecord
  self.table_name = 'csvfiles'

  belongs_to :user
  belongs_to :group

  # ActiveStorage
  has_one_attached :import_file
  has_one_attached :download_file
  validates :import_file, attached: true, if: Proc.new { |c| !c.download_file.attached? }
  validates :download_file, attached: true, if: Proc.new { |c| !c.import_file.attached? }

  # Paperclip TODO
  # has_attached_file :import_file, s3_permissions: 'private'
  # has_attached_file :download_file, s3_permissions: 'private',
  #                                   s3_headers: lambda { |attachment|
  #                                                  {
  #                                                      'Content-Type' => 'text/csv',
  #                                                      'Content-Disposition' => 'attachment',
  #                                                  }
  #                                                }
  # do_not_validate_attachment_file_type :import_file
  # do_not_validate_attachment_file_type :download_file

  after_commit :schedule_users_import, on: :create

  scope :download_files, -> { where("download_file_file_name <> ''") }

  def path_for_csv
    if File.exist?(self.import_file.path)
      self.import_file.path
    else
      # Paperclip.io_adapters.for(self.import_file).path
      ''
    end
  end

  protected

  def schedule_users_import
    return if self.download_file.attached?

    if group_id
      GroupMemberImportCSVJob.perform_later(self.id)
    else
      ImportCSVJob.perform_later(self.id)
    end
  end
end
