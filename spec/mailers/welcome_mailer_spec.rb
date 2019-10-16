require "rails_helper"

RSpec.describe WelcomeMailer, type: :mailer do
  let!(:enterprise) { create(:enterprise, disable_emails: false) }
  let!(:user) { create(:user, enterprise: enterprise) }	
  let!(:group) { create(:group, enterprise: enterprise) }

  let!(:mail) { described_class.notification(group.id, user.id).deliver_now }

  describe '#notification' do 
  	it 'the email is queued' do
  	  expect(ActionMailer::Base.deliveries).to_not be_empty
  	end

  	it 'renders the subject' do 
  	  expect(mail.subject).to eq "Notification"
  	end

  	it 'renders the receiver email' do
  	  expect(mail.to).to eq([user.email_for_notification])
  	end

  	it 'renders the sender email' do 
  	  expect(mail.from).to eq(['info@diverst.com'])
  	end
  end
end
