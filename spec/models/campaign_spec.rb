require 'rails_helper'

RSpec.describe Campaign, type: :model do
  describe 'when validating' do
    let(:campaign) { build_stubbed(:campaign) }

    it { expect(campaign).to define_enum_for(:status).with([:published, :draft, :closed, :reopened]) }
    it { expect(campaign).to belong_to(:enterprise) }
    it { expect(campaign).to belong_to(:owner).class_name('User') }
    it { expect(campaign).to have_many(:questions) }
    it { expect(campaign).to have_many(:campaigns_groups).dependent(:destroy) }
    it { expect(campaign).to have_many(:groups).through(:campaigns_groups) }
    it { expect(campaign).to have_many(:campaigns_segments).dependent(:destroy) }
    it { expect(campaign).to have_many(:segments).through(:campaigns_segments) }
    it { expect(campaign).to have_many(:invitations).class_name('CampaignInvitation').dependent(:destroy) }
    it { expect(campaign).to have_many(:users).through(:invitations) }
    it { expect(campaign).to have_many(:answers).through(:questions) }
    it { expect(campaign).to have_many(:answer_comments).through(:questions) }
    it { expect(campaign).to have_many(:answer_upvotes).through(:questions) }
    it { expect(campaign).to have_many(:campaigns_managers).dependent(:destroy) }
    it { expect(campaign).to have_many(:managers).through(:campaigns_managers).source(:user) }
    it { expect(campaign).to have_many(:sponsors).dependent(:destroy) }

    it { expect(campaign).to accept_nested_attributes_for(:questions).allow_destroy(true) }
    it { expect(campaign).to accept_nested_attributes_for(:sponsors).allow_destroy(true) }

    it { expect(campaign).to validate_presence_of(:title) }
    it { expect(campaign).to validate_presence_of(:description) }
    it { expect(campaign).to validate_presence_of(:start).with_message('must be after today') }
    it { expect(campaign).to validate_presence_of(:end).with_message('must be after start') }
    it { expect(campaign).to validate_presence_of(:groups).with_message('Please select at least 1 group') }

    it { expect(campaign).to validate_length_of(:banner_content_type).is_at_most(191) }
    it { expect(campaign).to validate_length_of(:banner_file_name).is_at_most(191) }
    it { expect(campaign).to validate_length_of(:image_content_type).is_at_most(191) }
    it { expect(campaign).to validate_length_of(:image_file_name).is_at_most(191) }
    it { expect(campaign).to validate_length_of(:description).is_at_most(65535) }
    it { expect(campaign).to validate_length_of(:title).is_at_most(191) }

    describe 'paperclip validation' do
      paperclip_attributes = [:image, :banner]
      paperclip_attributes.each do |paperclip_attribute|
        it { should have_attached_file(paperclip_attribute) }
        it { should validate_attachment_content_type(paperclip_attribute).allowing('image/png', 'image/gif')
            .rejecting('text/plain', 'text/xml')
        }
      end
    end
    it 'is valid' do
      expect(campaign).to be_valid
    end
  end

  describe '#top_campaign_performers' do
    let!(:campaign) { create(:campaign) }
    let!(:author) { create(:user, enterprise: campaign.enterprise) }
    let!(:question) { create(:question, campaign_id: campaign.id) }
    let!(:answers) { create_list(:answer, 3, author_id: author.id, question_id: question.id,
                                             idea_category_id: create(:idea_category, enterprise_id: campaign.enterprise_id).id)
    }
    let!(:reward_action) { create(:reward_action, label: 'Campaign answer',
                                                  points: 10,
                                                  key: 'campaign_answer',
                                                  enterprise: campaign.enterprise)
    }
    before do
      answers.each do |answer|
        create(:user_reward_action, user_id: author.id,
                                    answer_id: answer.id,
                                    points: 10,
                                    reward_action_id: reward_action.id)
      end
    end

    it 'get top campaign performers in hash' do
      expect(campaign.top_campaign_performers).to eq({ author.name => author.campaign_engagement_points(campaign) })
    end
  end

  describe '#engagement_activity_level' do
    let!(:campaign) { create(:campaign) }
    let!(:question) { create(:question, campaign_id: campaign.id) }
    let!(:answers) { create_list(:answer, 3, question_id: question.id,
                                             idea_category_id: create(:idea_category, enterprise_id: campaign.enterprise_id).id)
    }

    let!(:engagement_activity_level) { campaign.answers.size + campaign.answer_upvotes.size + campaign.answer_comments.size }

    it 'get engagement activity level' do
      expect(campaign.engagement_activity_level).to eq(engagement_activity_level)
    end
  end

  describe '#chosen ideas' do
    let!(:campaign) { create(:campaign) }
    let!(:question) { create(:question, campaign_id: campaign.id) }
    let!(:answers) { create_list(:answer, 3, question_id: question.id,
                                             chosen: true,
                                             idea_category_id: create(:idea_category, enterprise_id: campaign.enterprise_id).id)
    }

    it 'get chosen ideas' do
      expect(campaign.chosen_ideas).to eq(answers)
    end
  end

  describe '#total_roi' do
    let!(:campaign) { create(:campaign) }
    let!(:question) { create(:question, campaign_id: campaign.id) }
    let!(:answers) { create_list(:answer, 3, question_id: question.id,
                                             value: 10,
                                             idea_category_id: create(:idea_category, enterprise_id: campaign.enterprise_id).id)
    }
    let!(:total_roi) { answers.map(&:value).sum }

    it 'get total roi' do
      expect(campaign.total_roi).to eq(total_roi)
    end
  end

  describe '.total_roi_for_all_campaigns' do
    let!(:enterprise) { create(:enterprise) }
    let!(:campaigns) { create_list(:campaign, 2, enterprise: enterprise) }
    let!(:question1) { create(:question, campaign_id: campaigns[0].id) }
    let!(:answers1) { create_list(:answer, 3, question_id: question1.id,
                                              value: 10,
                                              idea_category_id: create(:idea_category, enterprise_id: campaigns[0].enterprise_id).id)
    }
    let!(:question2) { create(:question, campaign_id: campaigns[1].id) }
    let!(:answers2) { create_list(:answer, 4, question_id: question2.id,
                                              value: 10,
                                              idea_category_id: create(:idea_category, enterprise_id: campaigns[1].enterprise_id).id)
    }
    let!(:total_roi_for_all_campaigns) { enterprise.answers.map(&:value).sum }

    it 'get total roi for all campaigns' do
      expect(Campaign.total_roi_for_all_campaigns(enterprise)).to eq(total_roi_for_all_campaigns)
    end
  end

  describe '.roi_distribution' do
    let!(:enterprise) { create(:enterprise) }
    let!(:campaigns) { create_list(:campaign, 2, enterprise: enterprise) }
    let!(:question1) { create(:question, campaign_id: campaigns[0].id) }
    let!(:answers1) { create_list(:answer, 3, question_id: question1.id,
                                              value: 10,
                                              idea_category_id: create(:idea_category, enterprise_id: campaigns[0].enterprise_id).id)
    }
    let!(:question2) { create(:question, campaign_id: campaigns[1].id) }
    let!(:answers2) { create_list(:answer, 4, question_id: question2.id,
                                              value: 10,
                                              idea_category_id: create(:idea_category, enterprise_id: campaigns[1].enterprise_id).id)
    }

    it 'get roi distribution across campaigns, start with campaign[1]' do
      expect(Campaign.roi_distribution(enterprise.id, campaigns[1].id)).to eq({ campaigns[1].title => campaigns[1].total_roi,
                                                                                campaigns[0].title => campaigns[0].total_roi })
    end

    it 'get roi distribution across campaigns, start with campaign[0]' do
      expect(Campaign.roi_distribution(enterprise.id, campaigns[0].id)).to eq({ campaigns[0].title => campaigns[0].total_roi,
                                                                                campaigns[1].title => campaigns[1].total_roi })
    end
  end

  describe '.engagement_activity_distribution' do
    let!(:enterprise) { create(:enterprise) }
    let!(:campaigns) { create_list(:campaign, 2, enterprise: enterprise) }
    let!(:question1) { create(:question, campaign_id: campaigns[0].id) }
    let!(:answers1) { create_list(:answer, 3, question_id: question1.id,
                                              idea_category_id: create(:idea_category, enterprise_id: campaigns[0].enterprise_id).id)
    }
    let!(:question2) { create(:question, campaign_id: campaigns[1].id) }
    let!(:answers2) { create_list(:answer, 4, question_id: question2.id,
                                              idea_category_id: create(:idea_category, enterprise_id: campaigns[1].enterprise_id).id)
    }

    it 'get engagement activity level across campaigns, start with campaign[1]' do
      expect(Campaign.engagement_activity_distribution(enterprise.id, campaigns[1].id)).to eq({ campaigns[1].title => campaigns[1].engagement_activity_level,
                                                                                                campaigns[0].title => campaigns[0].engagement_activity_level })
    end

    it 'get engagement activity level across campaigns, start with campaign[0]' do
      expect(Campaign.engagement_activity_distribution(enterprise.id, campaigns[0].id)).to eq({ campaigns[0].title => campaigns[0].engagement_activity_level,
                                                                                                campaigns[1].title => campaigns[1].engagement_activity_level })
    end
  end

  describe '#create_invites' do
    it 'does not import' do
      campaign = create :campaign
      allow(CampaignInvitation).to receive(:import)

      campaign.enterprise = nil
      campaign.save
      campaign.create_invites

      expect(CampaignInvitation).to_not have_received(:import)
    end

    it 'does import' do
      enterprise = create :enterprise
      campaign = create :campaign, enterprise: enterprise
      allow(CampaignInvitation).to receive(:import)

      campaign.create_invites

      expect(CampaignInvitation).to have_received(:import)
    end
  end

  describe '#targeted_users' do
    let!(:enterprise) { create(:enterprise) }
    let!(:group1) { create(:group, enterprise: enterprise, pending_users: 'enabled') }
    let!(:group2) { create(:group, enterprise: enterprise, pending_users: 'enabled') }
    let!(:group1_users) { create_list(:user, 2, enterprise: enterprise, active: true) }
    let!(:group2_users) { create_list(:user, 3, enterprise: enterprise, active: true) }
    let!(:campaign) { create(:campaign, enterprise_id: enterprise.id, groups: [group1, group2]) }

    before do
      group1_users.each do |user|
        create(:user_group, user: user, group: group1)
      end

      group2_users.each do |user|
        create(:user_group, user: user, group: group2)
      end
    end

    it 'returns targeted users' do
      expect(campaign.targeted_users).to eq group1_users + group2_users
    end
  end

  describe '#progression' do
    it 'returns 0' do
      campaign = create :campaign
      expect(campaign.progression).to eq(0)
    end

    it 'returns 50.0' do
      campaign = create :campaign
      create_list :question, 5, campaign: campaign
      create_list :question, 5, campaign: campaign, solved_at: Date.today
      expect(campaign.progression).to eq(50.0)
    end
  end

  describe '#send_invitation_emails' do
    context 'when campaign is published' do
      let!(:campaign) { create(:campaign, status: Campaign.statuses[:published]) }
      let!(:invitation_sent) { create(:campaign_invitation, campaign: campaign, email_sent: true) }
      let!(:invitation_not_sent) { create(:campaign_invitation, campaign: campaign, email_sent: false) }

      it "send an email for invitations that didn't receive an email yet" do
        mailer = double('CampaignMailer')
        expect(CampaignMailer).to receive(:invitation).once.with(invitation_not_sent) { mailer }
        expect(mailer).to receive(:deliver_later)

        campaign.send_invitation_emails
      end
    end

    context 'when campaign is draft' do
      let(:campaign) { create(:campaign, status: Campaign.statuses[:draft]) }
      let!(:invitation_not_sent) { create(:campaign_invitation, campaign: campaign) }

      it 'do not send any email' do
        expect(CampaignMailer).to_not receive(:invitation)
        campaign.send_invitation_emails
      end
    end
  end

  describe 'start/end' do
    it 'validates end' do
      campaign = build(:campaign, end: Date.tomorrow)
      expect(campaign.valid?).to eq(false)
      expect(campaign.errors.full_messages.first).to eq('End must be after start')
    end
  end

  describe '#destroy_callbacks' do
    it 'removes the child objects' do
      campaign = create(:campaign)
      question = create(:question, campaign: campaign)
      campaigns_group = create(:campaigns_group, campaign: campaign)
      campaign_invitation = create(:campaign_invitation, campaign: campaign)
      campaigns_segment = create(:campaigns_segment, campaign: campaign)
      campaigns_manager = create(:campaigns_manager, campaign: campaign)

      campaign.destroy

      expect { Campaign.find(campaign.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Question.find(question.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { CampaignsGroup.find(campaigns_group.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { CampaignInvitation.find(campaign_invitation.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { CampaignsSegment.find(campaigns_segment.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { CampaignsManager.find(campaigns_manager.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#contributions_per_erg_csv' do
    it 'return csv report' do
      campaign = create(:campaign)
      expect(campaign.contributions_per_erg_csv('group')).to include "Contributions per #{campaign.enterprise.custom_text.erg.downcase}"
    end
  end

  describe '#top_performers_csv' do
    it 'returns csv report' do
      campaign = create(:campaign)

      expect(campaign.top_performers_csv).to include 'Top performers'
    end
  end
end
