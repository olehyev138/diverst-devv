class CsvUploadMailer < ApplicationMailer
  def result(successful_rows, failed_rows, count)
    @successful_rows = successful_rows
    @failed_rows = failed_rows
    @count = count

    s = 'User import result'
    email = ENV['CSV_UPLOAD_REPORT_EMAIL']
    email = 'tech@diverst.com' if email.blank?

    mail(to: email, subject: s)
  end
end
