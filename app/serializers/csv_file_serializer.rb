class CsvFileSerializer < ApplicationRecordSerializer
  attributes :id, :created_at,
             :download_file, :download_file_file_name, :download_file_data,
             :import_file, :import_file_file_name, :import_file_data,
             :file_name, :download_file_path

  def download_file
    AttachmentHelper.attachment_signed_id(object.download_file)
  end

  def download_file_file_name
    AttachmentHelper.attachment_file_name(object.download_file)
  end

  def download_file_data
    AttachmentHelper.attachment_data_string(object.download_file)
  end

  def download_file_path
    object.path_for_download
  end

  def file_name
    return nil unless object.download_file.attached?

    object.download_file_name + object.download_file.filename.extension_with_delimiter
  end

  def import_file
    AttachmentHelper.attachment_signed_id(object.import_file)
  end

  def import_file_file_name
    AttachmentHelper.attachment_file_name(object.import_file)
  end

  def import_file_data
    AttachmentHelper.attachment_data_string(object.import_file)
  end
end
