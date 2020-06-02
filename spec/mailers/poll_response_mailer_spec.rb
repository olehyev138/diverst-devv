require "rails_helper"

RSpec.describe PollResponseMailer, type: :mailer do
  include ActionView::Helpers

  describe "notification" do
    let!(:user) { create(:user) }
    let!(:poll) { create :poll }
    let!(:poll_response) { create(:poll_response, poll_id: poll.id, user_id: user.id) }
    let!(:custom_text) { create(:custom_text, erg: 'BRG', enterprise: user.enterprise) }
    let!(:email) { create(:email, enterprise: user.enterprise, mailer_name: 'poll_response_mailer', mailer_method: 'notification', content: "<p>Hello %{user.name},</p>\r\n\r\n<p>This is to confirm that your response to our survey has been received. Thank you for your participtaion!</p>", subject: "Thank you for participating in our '%{survey.title} survey") }
    let!(:email_variable_1) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'user.name')) }
    let!(:email_variable_2) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'survey.title')) }
    let!(:mail) { described_class.notification(poll, user).deliver_now }
    
    it 'renders the subject' do
      expect(mail.subject).to eq("Thank you for participating in our '#{poll.title} survey")
    end

    it 'includes message' do
      expect(mail.body.encoded).to include("This is to confirm that your response to our survey has been received. Thank you for your participtaion!")
    end

    it 'includes message in email body' do
      expect(mail.body.encoded).to include(user.name)
    end
  
    it 'renders the subject' do
      expect(mail.subject).to eq 'Notification'
    end
    
    it 'renders the receiver email' do
      expect(mail.to).to eq([poll_response.user.email_for_notification])
    end
  
    it 'renders the sender email' do
      expect(mail.from).to eq(['info@diverst.com'])
    end
  end
end
