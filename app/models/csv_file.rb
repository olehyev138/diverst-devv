class CsvFile < ApplicationRecord
  self.table_name = 'csvfiles'

  belongs_to :user
  belongs_to :group

  # ActiveStorage
  has_one_attached :import_file
  has_one_attached :download_file
  validates :import_file, attached: true, if: Proc.new { |c| !c.download_file.attached? }
  validates :download_file, attached: true, if: Proc.new { |c| !c.import_file.attached? }

  after_commit :schedule_users_import, on: :create

  scope :download_files, -> { where("download_file_name <> ''") }

  def path_for_csv
    ActiveStorage::Blob.service.send(:path_for, self.import_file.key)
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
