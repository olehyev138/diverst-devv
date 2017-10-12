require 'rails_helper'

RSpec.describe UserGroupMailer, type: :mailer do
  let!(:user){ create(:user) }
  let!(:groups){ [{ group: create(:group), messages_count: 2, news_count: 0 }] }

  let!(:mail) { described_class.notification(user, groups).deliver_now }

  describe '#notification' do
    it 'the email is queued' do
      expect(ActionMailer::Base.deliveries).to_not be_empty
    end

    it 'renders the subject' do
      expect(mail.subject).to eq "You have updates in your ERGs"
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['info@diverst.com'])
    end

    it 'shows a message with number of comments in group' do
      expect(mail.body.encoded).to include("2 new messages")
    end

    it 'does not shows a message with number of news when there is news' do
      expect(mail.body.encoded).to_not include("news")
    end
  end
end
