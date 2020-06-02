require "rails_helper"

RSpec.describe PollResponseMailer, type: :mailer do
  include ActionView::Helpers

  describe "notification" do
    let!(:enterprise) { create(:enterprise) }
    let!(:user) { create(:user, enterprise: enterprise) }
    let!(:user1) { create(:user, enterprise: enterprise) }
    let!(:poll) { create(:poll, owner_id: user.id) }
    let!(:response) { create(:poll_response, poll_id: poll.id, user_id: user1.id) }
    
    let(:mail) { PollResponseMailer.notification(response.id, user1.id) }

    context '#notification' do
      it 'renders the subject' do
        expect(mail.subject).to eq 'Notification'
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq([response.user.email_for_notification])
      end

      it 'renders the sender email' do
        expect(mail.from).to eq(['info@diverst.com'])
      end

      it 'shows a message to user' do
        expect(mail.body.decoded).to include('')
      end
    end
  end

end
