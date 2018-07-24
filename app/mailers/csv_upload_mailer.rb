class CsvUploadMailer < ApplicationMailer
  def result(successful_rows, failed_rows, count)
    @successful_rows = successful_rows
    @failed_rows = failed_rows
    @count = count

    s = 'User import result'
    email = ENV['CSV_UPLOAD_REPORT_EMAIL']
    mail(to: email, subject: s)
  end
end
