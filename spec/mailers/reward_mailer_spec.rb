require 'rails_helper'

RSpec.describe RewardMailer, type: :mailer do
  let!(:responsible){ create(:user) }
  let!(:user){ create(:user) }
  let!(:reward){ create(:reward) }

  let!(:mail) { described_class.redeem_reward(responsible, user, reward).deliver_now }

  describe '#notification' do
    it 'the email is queued' do
      expect(ActionMailer::Base.deliveries).to_not be_empty
    end

    it 'renders the subject' do
      expect(mail.subject).to eq "A reward was redeemed"
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([responsible.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['info@diverst.com'])
    end

    it 'shows a message to user' do
      expect(mail.body.encoded).to include("The user #{ user.name } redeemed the prize #{ reward.label }. Please contact him.")
    end
  end
end
