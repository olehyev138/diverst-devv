class ImportCSVJob < ActiveJob::Base
  queue_as :low

  def perform(file_id)
    file = CsvFile.find_by_id(file_id)
    return false if file.blank?

    enterprise_id = file.user.enterprise_id

    @importer = Importers::Users.new(file.path_for_csv, file.user)
    @importer.import

    CsvUploadMailer.result(
      @importer.successful_rows,
      @importer.failed_rows,
      @importer.table.count,
      enterprise_id
    ).deliver_now
  end
end
