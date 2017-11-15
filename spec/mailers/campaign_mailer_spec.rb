require 'rails_helper'

RSpec.describe CampaignMailer, type: :mailer do

    describe '#invitation' do
        let(:user) { create :user }
        let(:invitation) { create :campaign_invitation, user: user }

        let(:mail) { described_class.invitation(invitation).deliver_now }

        describe 'email subject' do
          let(:group_name) { invitation.campaign.groups.first.name }

          it 'includes group name' do
            expect(mail.subject).to include group_name
          end

          it 'includes message' do
            expect(mail.subject).to include('You are invited to join')
          end
        end

        it 'renders the receiver email' do
            expect(mail.to).to eq([user.email])
        end
    end
end
