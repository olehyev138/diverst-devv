class CsvFileSerializer < ApplicationRecordSerializer
  attributes :id, :download_file_path, :file_name, :created_at

  def download_file_path
    object.path_for_download
  end

  def file_name
    object.download_file_name + object.download_file.filename.extension_with_delimiter
  end
end
