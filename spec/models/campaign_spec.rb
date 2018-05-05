require 'rails_helper'

RSpec.describe Campaign, type: :model do
    describe 'when validating' do
        let(:campaign) { build_stubbed(:campaign) }

        it { expect(campaign).to define_enum_for(:status).with([:published, :draft]) }
        it { expect(campaign).to belong_to(:enterprise) }
        it { expect(campaign).to belong_to(:owner).class_name('User') }
        it { expect(campaign).to have_many(:questions) }
        it { expect(campaign).to have_many(:answers).through(:questions) }
        it { expect(campaign).to have_many(:answer_comments).through(:questions) }
        it { expect(campaign).to have_many(:campaigns_groups) }
        it { expect(campaign).to have_many(:groups).through(:campaigns_groups) }
        it { expect(campaign).to have_many(:campaigns_segments) }
        it { expect(campaign).to have_many(:segments).through(:campaigns_segments) }
        it { expect(campaign).to have_many(:invitations).class_name('CampaignInvitation') }
        it { expect(campaign).to have_many(:users).through(:invitations) }
        it { expect(campaign).to have_many(:campaigns_managers) }
        it { expect(campaign).to have_many(:managers).through(:campaigns_managers) }

        it { expect(campaign).to accept_nested_attributes_for(:questions).allow_destroy(true) }

        it{ expect(campaign).to validate_presence_of(:title) }
        it{ expect(campaign).to validate_presence_of(:description) }
        it{ expect(campaign).to validate_presence_of(:start) }
        it{ expect(campaign).to validate_presence_of(:end) }
        it{ expect(campaign).to validate_presence_of(:groups).with_message("Please select at least 1 group") }

        describe 'paperclip validation' do
            paperclip_attributes = [:image, :banner]
            paperclip_attributes.each do |paperclip_attribute|
                it { should have_attached_file(paperclip_attribute) }
                it { should validate_attachment_content_type(paperclip_attribute) }
            end
        end
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

    describe "start/end" do
        it "validates end" do
            campaign = build(:campaign, :end => Date.tomorrow)
            expect(campaign.valid?).to eq(false)
            expect(campaign.errors.full_messages.first).to eq("End must be after start")
        end
    end
    
    describe "#destroy_callbacks" do
        it "removes the child objects" do
            campaign = create(:campaign)
            question = create(:question, :campaign => campaign)
            campaigns_group = create(:campaigns_group, :campaign => campaign)
            campaign_invitation = create(:campaign_invitation, :campaign => campaign)
            campaigns_segment = create(:campaigns_segment, :campaign => campaign)
            campaigns_manager = create(:campaigns_manager, :campaign => campaign)
            
            campaign.destroy
            
            expect{Campaign.find(campaign.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{Question.find(question.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{CampaignsGroup.find(campaigns_group.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{CampaignInvitation.find(campaign_invitation.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{CampaignsSegment.find(campaigns_segment.id)}.to raise_error(ActiveRecord::RecordNotFound)
            expect{CampaignsManager.find(campaigns_manager.id)}.to raise_error(ActiveRecord::RecordNotFound)
        end
    end
end
