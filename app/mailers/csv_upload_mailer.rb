class CsvUploadMailer < ApplicationMailer
  def result(successful_rows, failed_rows, count, enterprise_id)
    @enterprise = Enterprise.find_by(id: enterprise_id)
    @successful_rows = successful_rows
    @failed_rows = failed_rows
    @count = count

    s = 'User import result'
    email = ENV['CSV_UPLOAD_REPORT_EMAIL']
    email = 'tech@diverst.com' if email.blank?

    set_defaults(@enterprise, method_name)

    mail(to: email, subject: s)
  end
end
