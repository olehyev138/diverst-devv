class ClearExpiredFilesJob < ActiveJob::Base
  queue_as :default

  def perform
    CsvFile.download_files.each do |csv_file|
      if (csv_file.created_at + 2.hours) < Time.now
        csv_file.destroy
      end
    end
  end
end
