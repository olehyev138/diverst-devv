require 'rails_helper'

RSpec.describe Campaign, type: :model do
    describe 'when validating' do
        let(:campaign) { build_stubbed(:campaign) }

        it { expect(campaign).to define_enum_for(:status).with([:published, :draft]) }
        it { expect(campaign).to belong_to(:enterprise) }
        it { expect(campaign).to belong_to(:owner) }
        it { expect(campaign).to have_many(:questions) }
        it { expect(campaign).to have_many(:answers).through(:questions) }
        it { expect(campaign).to have_many(:answer_comments).through(:questions) }
        it { expect(campaign).to have_many(:campaigns_groups) }
        it { expect(campaign).to have_many(:groups).through(:campaigns_groups) }
        it { expect(campaign).to have_many(:campaigns_segments) }
        it { expect(campaign).to have_many(:segments).through(:campaigns_segments) }
        it { expect(campaign).to have_many(:invitations) }
        it { expect(campaign).to have_many(:users).through(:invitations) }
        it { expect(campaign).to have_many(:campaigns_managers) }
        it { expect(campaign).to have_many(:managers).through(:campaigns_managers) }

        it 'is valid' do
            expect(campaign).to be_valid
        end
    end
    
    describe "#create_invites" do
        it "does not import" do
            campaign = create :campaign
            allow(CampaignInvitation).to receive(:import)
            
            campaign.enterprise = nil
            campaign.save
            campaign.create_invites
            
            expect(CampaignInvitation).to_not have_received(:import)
        end
        
        it "does import" do
            enterprise = create :enterprise
            campaign = create :campaign, enterprise: enterprise
            allow(CampaignInvitation).to receive(:import)

            campaign.create_invites
            
            expect(CampaignInvitation).to have_received(:import)
        end
    end
    
    describe "#progression" do
        it "returns 0" do
            campaign = create :campaign
            expect(campaign.progression).to eq(0)
        end
        
        it "returns 50.0" do
            campaign = create :campaign
            create_list :question, 5, campaign: campaign
            create_list :question, 5, campaign: campaign, solved_at: Date.today
            expect(campaign.progression).to eq(50.0)
        end
    end

    describe "#send_invitation_emails" do
        context "when campaign is published" do
            let!(:campaign){ create(:campaign, status: Campaign.statuses[:published]) }
            let!(:invitation_sent){ create(:campaign_invitation, campaign: campaign, email_sent: true) }
            let!(:invitation_not_sent){ create(:campaign_invitation, campaign: campaign, email_sent: false) }

            it "send an email for invitations that didn't receive an email yet" do
                mailer = double("CampaignMailer")
                expect(CampaignMailer).to receive(:invitation).once.with(invitation_not_sent){ mailer }
                expect(mailer).to receive(:deliver_later)

                campaign.send_invitation_emails
            end
        end

        context "when campaign is draft" do
            let(:campaign){ create(:campaign, status: Campaign.statuses[:draft]) }
            let!(:invitation_not_sent){ create(:campaign_invitation, campaign: campaign) }

            it "do not send any email" do
                expect(CampaignMailer).to_not receive(:invitation)
                campaign.send_invitation_emails
            end
        end
    end
end
