require 'rails_helper'

RSpec.describe RewardMailer, type: :mailer do
  let!(:responsible) { create(:user, first_name: 'Cali', last_name: "O'Connell") }
  let!(:user) { create(:user, first_name: 'Cali', last_name: "O'Connell") }
  let!(:reward) { create(:reward) }

  let!(:mail) { described_class.redeem_reward(responsible, user, reward).deliver_now }

  describe '#redeem_reward' do
    it 'the email is queued' do
      expect(ActionMailer::Base.deliveries).to_not be_empty
    end

    it 'renders the subject' do
      expect(mail.subject).to eq 'A reward was redeemed'
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([responsible.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['info@diverst.com'])
    end

    it 'shows a message to user' do
      # user name with apostrophe will cause test to fail - ex: Cali O'Connell
      # so we escape the string
      name = CGI.escapeHTML("#{user.name}")
      expect(mail.body.decoded).to include("The user #{ name } redeemed the prize #{ reward.label }. Please contact him.")
    end
  end

  context 'when enterprise wants to redirect emails and redirect_email_contact is set' do
    describe '#redeem_reward' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: 'test@gmail.com') }
      let!(:responsible) { create(:user, enterprise: enterprise) }
      let!(:user) { create(:user, enterprise: enterprise) }
      let!(:reward) { create(:reward) }

      let!(:mail) { described_class.redeem_reward(responsible, user, reward).deliver_now }

      it 'renders the redirect_email_contact' do
        expect(mail.to).to eq([enterprise.redirect_email_contact])
      end
    end
  end

  context 'when enterprise wants to redirect emails but redirect_email_contact is to blank' do
    describe '#redeem_reward' do
      let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: '') }
      let(:fallback_email) { ENV['REDIRECT_ALL_EMAILS_TO'] || 'sanetiming@gmail.com' }
      let!(:responsible) { create(:user, enterprise: enterprise) }
      let!(:user) { create(:user, enterprise: enterprise) }
      let!(:reward) { create(:reward) }

      let!(:mail) { described_class.redeem_reward(responsible, user, reward).deliver_now }

      it 'renders the fallback_email' do
        expect(mail.to).to eq([fallback_email])
      end
    end
  end

  context 'when enterprise wants to stop all emails' do
    describe '#redeem_reward' do
      let(:enterprise) { create(:enterprise, disable_emails: true) }
      let!(:responsible) { create(:user, enterprise: enterprise) }
      let!(:user) { create(:user, enterprise: enterprise) }
      let!(:reward) { create(:reward) }

      let!(:mail) { described_class.redeem_reward(responsible, user, reward).deliver_now }

      it 'renders null mail object' do
        expect(mail).to be(nil)
      end
    end
  end
end
