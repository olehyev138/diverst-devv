require 'rails_helper'

RSpec.describe CampaignMailer, type: :mailer do
    
    describe '#invitation' do
        let(:user) { create :user }
        let(:invitation) { create :campaign_invitation, user: user }
        
        let(:mail) { described_class.invitation(invitation).deliver_now }
        
        it 'renders the subject' do
            expect(mail.subject).to eq("Help your coworkers solve a problem")
        end
        
        it 'renders the receiver email' do
            expect(mail.to).to eq([user.email])
        end
    end
end
