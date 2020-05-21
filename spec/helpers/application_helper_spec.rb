require 'rails_helper'

RSpec.describe ApplicationHelper do
  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise) }

  before do
    allow(helper).to receive(:current_user).and_return(user)
  end

  describe '#linkedin_logo_for_connected_users' do
    include InlineSvg::ActionView::Helpers

    it 'returns linkedin logo if linkedin url is present for user' do
      allow(user).to receive(:linkedin_profile_url).and_return('https://www.linkedin.com/in/derek-owusu-frimpong-b5b96372/')
      expect(helper.linkedin_logo_for_connected_users(user)).to eq inline_svg('icons/linkedin', size: '17px*17px')
    end
  end

  describe '#logo_url' do
    it 'returns default enterprise logo when enterprise.theme and enterprise.theme.logo are absent' do
      expect(helper.logo_url(enterprise)).to include 'diverst-logo'
    end

    it 'returns custom enterprise logo when enterprise.theme and enterprise' do
      enterprise.update(theme_id: create(:theme).id)
      expect(helper.logo_url(enterprise)).to eq enterprise.theme.logo.expiring_url(3601)
    end
  end

  describe '#small_logo_url' do
    it 'returns default logo when enterprise.theme and enterprise.theme.logo are absent' do
      expect(helper.small_logo_url(enterprise)).to include 'diverst-logo-mark'
    end

    it 'returns custom enterprise logo when enterprise.theme and enterprise' do
      enterprise.update(theme_id: create(:theme).id)
      expect(helper.small_logo_url(enterprise)).to eq enterprise.theme.logo.expiring_url(3601)
    end
  end

  describe '#login_logo' do
    it 'returns default logo when enterprise.theme and enterprise.theme.logo are absent' do
      expect(helper.login_logo(enterprise)).to include 'diverst-logo-purple'
    end

    it 'returns custom enterprise logo when enterprise.theme and enterprise' do
      enterprise.update(theme_id: create(:theme).id)
      expect(helper.login_logo(enterprise)).to eq enterprise.theme.logo.expiring_url(3601)
    end
  end

  describe '#logo_destination' do
    # NOTE the opposite, where current_user is present also returns user_root_path because user_root_path
    # is returned for a different condition
    it 'returns user_root_path if current_user is absent' do
      user = nil
      expect(helper.logo_destination).to eq user_root_path
    end

    it 'returns logo_redirect_url when theme and logo are present for enterprise' do
      enterprise.update(theme_id: create(:theme, logo_redirect_url: 'some/logo').id)
      expect(helper.logo_destination).to eq enterprise.theme.logo_redirect_url
    end

    it 'returns user_root_path when theme and logo are absent for enterprise' do
      expect(helper.logo_destination).to eq user_root_path
    end
  end

  describe '#event_color' do
    let!(:group) { create(:group, enterprise: enterprise) }
    let(:outcome) { create :outcome, group_id: group.id }
    let(:pillar) { create :pillar, outcome_id: outcome.id }
    let!(:initiative) { create :initiative, pillar: pillar, owner_group: group }

    it 'returns calendar_color if present' do
      expect(helper.event_color(initiative)).to eq '#' + initiative.group.calendar_color
    end

    it 'returns enterprise_primary_logo' do
      enterprise.update(theme_id: create(:theme).id)
      expect(helper.event_color(initiative)).to eq enterprise.theme.primary_color
    end

    it "returns '#7b77c9' when enterprise.theme is nil and calendar_color is nil" do
      initiative.group.update(calendar_color: '')
      expect(helper.event_color(initiative)).to eq '#7b77c9'
    end
  end

  describe '#to_color' do
    it 'returns valid color code' do
      expect(helper.to_color('#808080')).to eq '#808080'
    end
  end

  describe '#enterprise_primary_color' do
    it 'returns primary_color of enterprise.theme' do
      enterprise.update(theme_id: create(:theme).id)
      expect(helper.enterprise_primary_color(enterprise)).to eq enterprise.theme.primary_color
    end

    it 'returns nil if enterprise.theme is absent' do
      expect(helper.enterprise_primary_color).to eq nil
    end
  end

  describe '#last_sign_in_text' do
    it 'returns Never if user has never signed in' do
      expect(helper.last_sign_in_text(user)).to eq 'Never'
    end

    it 'returns time signed in last in words if user has signed in last' do
      user.update(last_sign_in_at: Time.new)
      expect(helper.last_sign_in_text(user)).to eq "#{time_ago_in_words(user.last_sign_in_at)} ago"
    end
  end

  describe '#root_admin_path' do
    before do
      user.policy_group = create(:policy_group, :no_permissions)
    end

    context 'returns manage_erg_root_path when' do
      it 'MetricsDashboardPolicy returns true for .index?' do
        user.policy_group.update(manage_all: true)
        expect(helper.root_admin_path).to eq metrics_overview_index_path
      end

      it 'GroupPolicy returns true for .create?' do
        user.policy_group.update(groups_create: true)
        expect(helper.root_admin_path).to eq groups_path
      end

      it 'SegmentPolicy returns true for .index?' do
        user.policy_group.update(segments_create: true)
        expect(helper.root_admin_path).to eq segments_path
      end

      it 'GroupPolicy returns true for .calendar?' do
        user.policy_group.update(global_calendar: true)
        expect(helper.root_admin_path).to eq calendar_groups_path
      end

      it 'EnterpriseFolderPolicy returns true for .index?' do
        user.policy_group.update(enterprise_resources_index: true)
        expect(helper.root_admin_path).to eq enterprise_folders_path(user.enterprise)
      end

      it 'returns false for no policy set' do
        expect(helper.root_admin_path).to eq false
      end
    end

    context 'returns manage_erg_budgets_path' do
      it 'returns false for no policy set' do
        expect(helper.root_admin_path).to eq false
      end
    end

    context 'returns campaigns_path' do
      it 'when CampaignPolicy returns true for .create?' do
        user.policy_group.update(campaigns_create: true)
        expect(helper.root_admin_path).to eq campaigns_path
      end
    end

    context 'returns polls_path' do
      it 'when PollPolicy returns true for .create?' do
        user.policy_group.update(polls_create: true)
        expect(helper.root_admin_path).to eq polls_path
      end
    end

    context 'returns mentoring_path' do
      # NOTE do we want to return mentoring_path or mentorings_path?
      it 'when MentoringInterestPolicy returns true for .index?' do
        user.policy_group.update(mentorship_manage: true)
        expect(helper.root_admin_path).to eq mentoring_interests_path
      end
    end

    context 'returns global_settings_path' do
      it 'returns users_path when UserPolicy is true for .create?' do
        user.policy_group.update(users_manage: true)
        expect(helper.root_admin_path).to eq users_path
      end

      it 'returns edit_auth_enterprise_path when EnterprisePolicy is true for .sso_manage?' do
        user.policy_group.update(sso_manage: true)
        expect(helper.root_admin_path).to eq edit_auth_enterprise_path(user.enterprise)
      end

      it 'returns policy_group_templates_path when EnterprisePolicy is true for .manage_permissions?' do
        user.policy_group.update(permissions_manage: true)
        expect(helper.root_admin_path).to eq policy_group_templates_path
      end


      it 'returns edit_branding_enterprise_path when EnterprisePolicy is true for .manage_branding?' do
        user.policy_group.update(branding_manage: true)
        expect(helper.root_admin_path).to eq edit_branding_enterprise_path(user.enterprise)
      end

      it 'returns rewards_path when EnterprisePolicy is true for .diversity_manage?' do
        user.policy_group.update(diversity_manage: true)
        expect(helper.root_admin_path).to eq rewards_path
      end

      it 'returns logs_path when LogPolicy is true for .index?' do
        user.policy_group.update(logs_view: true)
        expect(helper.root_admin_path).to eq logs_path
      end

      it 'returns user_path if no policy is set' do
        expect(helper.default_path).to eq user_root_path
      end
    end

    describe '#default_enterprise_asset_url' do
      it 'returns application if enterprpise or enterprise.theme is nil' do
        expect(helper.default_enterprise_asset_url).to eq 'application'
      end

      it 'returns enterprise.theme.asset_url' do
        enterprise.update(theme_id: create(:theme).id)
        expect(helper.default_enterprise_asset_url).to eq enterprise.theme.asset_url
      end
    end

    describe '#c_t' do
      it 'returns custom_text' do
        expect(helper.c_t(:badge)).to eq 'Badge'
      end
    end

    describe '#show_sponsor?' do
      it 'yields a block when object responds to sponsor_name' do
        group_sponsor = create(:sponsor, sponsor_name: 'Bill Gates', sponsor_media: File.open('spec/fixtures/video_file/sponsor_video.mp4'))
        expect(helper.show_sponsor?(group_sponsor)).to eq true
      end
    end


    describe '#show_sponsor_video?' do
      it 'yields a block when sponsor_media is present' do
        group_sponsor = create(:sponsor, sponsor_media: File.open('spec/fixtures/video_file/sponsor_video.mp4'))
        expect(helper.show_sponsor_video?(group_sponsor, 'sponsor_media_content_type') { 'hello world' }).to eq 'hello world'
      end
    end

    describe '#show_sponsor_media?' do
      it 'yields a block when sponsor_media is present' do
        group_sponsor = create(:sponsor, sponsor_media: File.open('spec/fixtures/files/sponsor_image.jpg'))
        expect(helper.show_sponsor_media?(group_sponsor, 'sponsor_media_content_type') { 'hello world' }).to eq 'hello world'
      end
    end

    describe '#segment_members_of_group' do
      let!(:segment) { create(:segment, enterprise_id: enterprise.id) }
      let!(:group) { create(:group, enterprise_id: enterprise.id) }
      let!(:users_segment) { create(:users_segment, segment_id: segment.id, user_id: user.id) }
      let!(:user_group) { create(:user_group, group_id: group.id, user_id: user.id) }

      it 'returns true if members of segment are also members of group' do
        expect(helper.segment_members_of_group(segment, group)).to eq [user]
      end
    end

    describe '#resource_policy' do
      let!(:group) { create(:group, enterprise_id: enterprise.id) }

      it 'EnterpriseResourcePolicy object when enterprise resource is present' do
        enterprise_resource = create(:resource, enterprise_id: enterprise.id)
        expect(helper.resource_policy(enterprise_resource)).to be_a EnterpriseResourcePolicy
      end

      it 'GroupResourcePolicy object when group resource is present' do
        group_resource = create(:resource, folder: create(:folder))
        expect(helper.resource_policy(group_resource)).to be_a GroupResourcePolicy
      end
    end
  end
end
