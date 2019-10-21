require 'rails_helper'

RSpec.describe RewardMailerJob, type: :job do
  include ActiveJob::TestHelper

  let!(:enterprise) { create(:enterprise, disable_emails: false) }
  let!(:user) { create(:user, enterprise: enterprise) }
  let!(:reward) { create(:reward, enterprise: enterprise, points: 10) }

  let(:pending_reward) { create(:user_reward, status: 0,
                                              points: 10,
                                              user_id: user.id,
                                              reward_id: reward.id)
  }

  describe 'sends reward mailer' do
    context 'when user_reward is' do
      it 'pending' do
        mailer = double('mailer')

        expect(RewardMailer).to receive(:request_to_redeem_reward) { mailer }
        expect(mailer).to receive(:deliver_later)
        subject.perform(pending_reward.id)
      end

      it 'redeemed' do
        pending_reward.update(status: 1)
        redeemed_reward = pending_reward

        mailer = double('mailer')

        expect(RewardMailer).to receive(:approve_reward) { mailer }
        expect(mailer).to receive(:deliver_later)
        subject.perform(redeemed_reward.id)
      end

      it 'forfeited' do
        pending_reward.update(status: 2)
        forfeited_reward = pending_reward

        mailer = double('mailer')

        expect(RewardMailer).to receive(:forfeit_reward) { mailer }
        expect(mailer).to receive(:deliver_later)
        subject.perform(forfeited_reward.id)
      end
    end
  end
end
