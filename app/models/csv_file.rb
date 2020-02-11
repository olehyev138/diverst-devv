class CsvFile < ApplicationRecord
  self.table_name = 'csvfiles'

  belongs_to :user
  belongs_to :group

  # ActiveStorage
  has_one_attached :import_file
  has_one_attached :download_file
  validates :import_file, attached: true, if: Proc.new { |c| !c.download_file.attached? }
  validates :download_file, attached: true, if: Proc.new { |c| !c.import_file.attached? }

  # TODO Remove after Paperclip to ActiveStorage migration
  has_attached_file :import_file_paperclip, s3_permissions: 'private'
  has_attached_file :download_file_paperclip, s3_permissions: 'private'

  validates_presence_of :download_file_name, if: Proc.new { |c| c.download_file.attached? }

  after_commit :schedule_users_import, on: :create
  before_save :generate_download_file_name, if: Proc.new { |c| c.download_file.attached? }

  scope :download_files, -> { where("download_file_name <> ''") }

  def path_for_csv
    return nil unless self.import_file.attached?

    ActiveStorage::Blob.service.send(:path_for, self.import_file.key)
  end

  def path_for_download
    return nil unless self.download_file.attached?

    Rails.application.routes.url_helpers.rails_blob_path(self.download_file, only_path: true, disposition: 'attachment')
  end

  protected

  def generate_download_file_name
    return if download_file_name.present?

    self.download_file_name = download_file.filename.base
  end

  def schedule_users_import
    return if self.download_file.attached?

    if group_id
      GroupMemberImportCSVJob.perform_later(self.id)
    else
      ImportCSVJob.perform_later(self.id)
    end
  end
end
