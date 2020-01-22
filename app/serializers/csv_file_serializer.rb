class CsvFileSerializer < ApplicationRecordSerializer
  attributes :download_file_location

  def download_file_location
    object.path_for_download
  end
end
