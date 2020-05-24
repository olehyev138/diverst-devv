# Preview all emails at http://localhost:3000/rails/mailers/poll_response_mailer
class PollResponseMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/poll_response_mailer/notification
  def notification
    PollResponseMailer.notification
  end
end
