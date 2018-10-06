require 'rails_helper'

RSpec.describe CampaignMailer, type: :mailer do

    describe '#invitation' do
        let(:user) { create :user }
        let(:invitation) { create :campaign_invitation, user: user }
        let!(:email) { create(:email, :enterprise => user.enterprise, :mailer_name => "campaign_mailer", :mailer_method => "invitation", :content => "<p>Hello %{user.name},</p>\r\n\r\n<p>You are invited to join other members in the following online collaborative conversation in Diverst: %{campaign.title}</p>\r\n\r\n<p>%{campaign.link} to provide feedback and offer your thoughts and suggestions.</p>\r\n", :subject => "You are invited to join %{group_names} in an online conversation in Diverst.")}
        let!(:email_variable_1) { create(:email_variable, :email => email, :enterprise_email_variable => create(:enterprise_email_variable, :key => "user.name"))}
        let!(:email_variable_2) { create(:email_variable, :email => email, :enterprise_email_variable => create(:enterprise_email_variable, :key => "campaign.title"))}
        let!(:email_variable_3) { create(:email_variable, :email => email, :enterprise_email_variable => create(:enterprise_email_variable, :key => "campaign.link"))}
        let!(:email_variable_4) { create(:email_variable, :email => email, :enterprise_email_variable => create(:enterprise_email_variable, :key => "group_name"))}
        let(:mail) { described_class.invitation(invitation).deliver_now }

        describe 'email subject' do
          let(:group_name) { invitation.campaign.groups.first.name }

          it 'includes group name' do
            expect(mail.subject).to include group_name
          end

          it 'includes message' do
            expect(mail.subject).to include('You are invited to join')
          end
          
          it 'includes message in email body' do
            expect(mail.body.encoded).to include(user.name)
            expect(mail.body.encoded).to include("Join Now")
          end
        end

        it 'renders the receiver email' do
            expect(mail.to).to eq([user.email])
        end
    end
end
