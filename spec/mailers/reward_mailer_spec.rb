require 'rails_helper'

RSpec.describe RewardMailer, type: :mailer do
  include ActionView::Helpers

  describe '#request_to_redeem_rewards' do
    let!(:enterprise) { create(:enterprise) }
    let!(:user) { create(:user, enterprise: enterprise) }
    let!(:reward) { create(:reward, enterprise: enterprise) }
    let!(:responsible) { reward.responsible }
    let!(:user_reward) { create(:user_reward, reward_id: reward.id, user_id: user.id) }

    let!(:mail) { described_class.request_to_redeem_reward(user_reward.id).deliver_now }

    context '#request_to_redeem_reward' do
      it 'the email is queued' do
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end

      it 'renders the subject' do
        expect(mail.subject).to eq 'A request for reward redemption'
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq([responsible.email])
      end

      it 'renders the sender email' do
        expect(mail.from).to eq(['info@diverst.com'])
      end

      it 'shows a message to user' do
        expect(mail.body.decoded).to include("The user #{user.name} has requested to redeem a reward #{reward.label}. Please click #{link_to 'here', users_pending_rewards_users_url} to approve or deny the request.
".html_safe)
      end

      context 'when enterprise wants to redirect emails and redirect_email_contact is set' do
        let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: 'test@gmail.com') }
        let!(:responsible) { create(:user, enterprise: enterprise) }
        let!(:user) { create(:user, enterprise: enterprise) }
        let!(:reward) { create(:reward, responsible_id: responsible.id) }
        let!(:user_reward) { create(:user_reward, reward_id: reward.id, user_id: user.id) }

        let!(:mail) { described_class.request_to_redeem_reward(user_reward.id).deliver_now }

        it 'renders the redirect_email_contact' do
          expect(mail.to).to eq([enterprise.redirect_email_contact])
        end
      end

      context 'when enterprise wants to redirect emails but redirect_email_contact is to blank' do
        let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: '') }
        let(:fallback_email) { ENV['REDIRECT_ALL_EMAILS_TO'] || 'sanetiming@gmail.com' }
        let!(:responsible) { create(:user, enterprise: enterprise) }
        let!(:user) { create(:user, enterprise: enterprise) }
        let!(:reward) { create(:reward, responsible_id: responsible.id) }
        let!(:user_reward) { create(:user_reward, reward_id: reward.id, user_id: user.id) }

        let!(:mail) { described_class.request_to_redeem_reward(user_reward).deliver_now }

        it 'renders the fallback_email' do
          expect(mail.to).to eq([fallback_email])
        end
      end

      context 'when enterprise wants to stop all emails' do
        let(:enterprise) { create(:enterprise, disable_emails: true) }
        let!(:responsible) { create(:user, enterprise: enterprise) }
        let!(:user) { create(:user, enterprise: enterprise) }
        let!(:reward) { create(:reward, responsible_id: responsible.id) }
        let!(:user_reward) { create(:user_reward, reward_id: reward.id, user_id: user.id) }

        let!(:mail) { described_class.request_to_redeem_reward(user_reward).deliver_now }

        it 'renders null mail object' do
          expect(mail).to be(nil)
        end
      end
    end
  end

  describe '#approve_rewards' do
    let!(:enterprise) { create(:enterprise) }
    let!(:user) { create(:user, enterprise: enterprise) }
    let!(:reward) { create(:reward, enterprise: enterprise) }
    let!(:responsible) { reward.responsible }
    let!(:user_reward) { create(:user_reward, reward_id: reward.id, user_id: user.id) }

    let!(:mail) { described_class.approve_reward(user_reward.id).deliver_now }

    context '#approve_reward' do
      it 'the email is queued' do
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end

      it 'renders the subject' do
        expect(mail.subject).to eq 'Reward Approval'
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq([user.email])
      end

      it 'renders the sender email' do
        expect(mail.from).to eq(['info@diverst.com'])
      end

      it 'shows a message to user' do
        expect(mail.body.decoded).to include("Congratulations #{user.name}! Your reward (#{reward.label}) has been approved and you will be contacted with more details shortly.".html_safe)
      end

      context 'when enterprise wants to redirect emails and redirect_email_contact is set' do
        let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: 'test@gmail.com') }
        let!(:responsible) { create(:user, enterprise: enterprise) }
        let!(:user) { create(:user, enterprise: enterprise) }
        let!(:reward) { create(:reward, responsible_id: responsible.id) }
        let!(:user_reward) { create(:user_reward, reward_id: reward.id, user_id: user.id) }

        let!(:mail) { described_class.approve_reward(user_reward.id).deliver_now }

        it 'renders the redirect_email_contact' do
          expect(mail.to).to eq([enterprise.redirect_email_contact])
        end
      end

      context 'when enterprise wants to redirect emails but redirect_email_contact is to blank' do
        let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: '') }
        let(:fallback_email) { ENV['REDIRECT_ALL_EMAILS_TO'] || 'sanetiming@gmail.com' }
        let!(:responsible) { create(:user, enterprise: enterprise) }
        let!(:user) { create(:user, enterprise: enterprise) }
        let!(:reward) { create(:reward, responsible_id: responsible.id) }
        let!(:user_reward) { create(:user_reward, reward_id: reward.id, user_id: user.id) }

        let!(:mail) { described_class.approve_reward(user_reward).deliver_now }

        it 'renders the fallback_email' do
          expect(mail.to).to eq([fallback_email])
        end
      end

      context 'when enterprise wants to stop all emails' do
        let(:enterprise) { create(:enterprise, disable_emails: true) }
        let!(:responsible) { create(:user, enterprise: enterprise) }
        let!(:user) { create(:user, enterprise: enterprise) }
        let!(:reward) { create(:reward, responsible_id: responsible.id) }
        let!(:user_reward) { create(:user_reward, reward_id: reward.id, user_id: user.id) }

        let!(:mail) { described_class.approve_reward(user_reward).deliver_now }

        it 'renders null mail object' do
          expect(mail).to be(nil)
        end
      end
    end
  end

  describe '#forfeit_rewards' do
    let!(:enterprise) { create(:enterprise) }
    let!(:user) { create(:user, enterprise: enterprise) }
    let!(:reward) { create(:reward, enterprise: enterprise) }
    let!(:responsible) { reward.responsible }
    let!(:user_reward) { create(:user_reward, reward_id: reward.id, user_id: user.id) }

    let!(:mail) { described_class.forfeit_reward(user_reward.id).deliver_now }

    context '#forfeit_reward' do
      it 'the email is queued' do
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end

      it 'renders the subject' do
        expect(mail.subject).to eq 'Reward Request Denied'
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq([user.email])
      end

      it 'renders the sender email' do
        expect(mail.from).to eq(['info@diverst.com'])
      end

      it 'shows a message to user' do
        # byebug
        expect(mail.body.decoded).to include("Sorry, #{user.name}. Your reward (#{reward.label}) has been denied
#{unless user_reward.comment.blank?
 "due to the following reason:\n#{user_reward.comment}" 
user_reward.comment
end}Contact the administrator for more details.".html_safe)
      end

      context 'when enterprise wants to redirect emails and redirect_email_contact is set' do
        let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: 'test@gmail.com') }
        let!(:responsible) { create(:user, enterprise: enterprise) }
        let!(:user) { create(:user, enterprise: enterprise) }
        let!(:reward) { create(:reward, responsible_id: responsible.id) }
        let!(:user_reward) { create(:user_reward, reward_id: reward.id, user_id: user.id) }

        let!(:mail) { described_class.forfeit_reward(user_reward.id).deliver_now }

        it 'renders the redirect_email_contact' do
          expect(mail.to).to eq([enterprise.redirect_email_contact])
        end
      end

      context 'when enterprise wants to redirect emails but redirect_email_contact is to blank' do
        let(:enterprise) { create(:enterprise, redirect_all_emails: true, redirect_email_contact: '') }
        let(:fallback_email) { ENV['REDIRECT_ALL_EMAILS_TO'] || 'sanetiming@gmail.com' }
        let!(:responsible) { create(:user, enterprise: enterprise) }
        let!(:user) { create(:user, enterprise: enterprise) }
        let!(:reward) { create(:reward, responsible_id: responsible.id) }
        let!(:user_reward) { create(:user_reward, reward_id: reward.id, user_id: user.id) }

        let!(:mail) { described_class.forfeit_reward(user_reward).deliver_now }

        it 'renders the fallback_email' do
          expect(mail.to).to eq([fallback_email])
        end
      end

      context 'when enterprise wants to stop all emails' do
        let(:enterprise) { create(:enterprise, disable_emails: true) }
        let!(:responsible) { create(:user, enterprise: enterprise) }
        let!(:user) { create(:user, enterprise: enterprise) }
        let!(:reward) { create(:reward, responsible_id: responsible.id) }
        let!(:user_reward) { create(:user_reward, reward_id: reward.id, user_id: user.id) }

        let!(:mail) { described_class.forfeit_reward(user_reward).deliver_now }

        it 'renders null mail object' do
          expect(mail).to be(nil)
        end
      end
    end
  end
end
