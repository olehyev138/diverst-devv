require 'rails_helper'

RSpec.describe Enterprise, type: :model do
  describe 'when validating' do
    let(:enterprise) { build_stubbed(:enterprise) }

    it { expect(enterprise).to have_many(:users).inverse_of(:enterprise).dependent(:destroy) }
    it { expect(enterprise).to have_many(:graph_fields).class_name('Field').dependent(:destroy) }
    it { expect(enterprise).to have_many(:fields).dependent(:destroy) }
    it { expect(enterprise).to have_many(:topics).inverse_of(:enterprise).dependent(:destroy) }
    it { expect(enterprise).to have_many(:segments).inverse_of(:enterprise).dependent(:destroy) }
    it { expect(enterprise).to have_many(:groups).inverse_of(:enterprise).dependent(:destroy) }
    it { expect(enterprise).to have_many(:initiatives).through(:groups) }
    it { expect(enterprise).to have_many(:folders).dependent(:destroy) }
    it { expect(enterprise).to have_many(:folder_shares).dependent(:destroy) }
    it { expect(enterprise).to have_many(:shared_folders).through(:folder_shares).source('folder') }
    it { expect(enterprise).to have_many(:polls).inverse_of(:enterprise).dependent(:destroy) }
    it { expect(enterprise).to have_many(:mobile_fields).inverse_of(:enterprise).dependent(:destroy) }
    it { expect(enterprise).to have_many(:metrics_dashboards).inverse_of(:enterprise).dependent(:destroy) }
    it { expect(enterprise).to have_many(:user_roles).inverse_of(:enterprise).dependent(:delete_all) }
    it { expect(enterprise).to have_many(:graphs).through(:metrics_dashboards) }
    it { expect(enterprise).to have_many(:poll_graphs).through(:polls).source(:graphs) }
    it { expect(enterprise).to have_many(:campaigns).dependent(:destroy) }
    it { expect(enterprise).to have_many(:questions).through(:campaigns) }
    it { expect(enterprise).to have_many(:answers).through(:questions) }
    it { expect(enterprise).to have_many(:answer_comments).through(:answers).source(:comments) }
    it { expect(enterprise).to have_many(:answer_upvotes).through(:answers).source(:votes) }
    it { expect(enterprise).to have_many(:resources).dependent(:destroy) }
    it { expect(enterprise).to have_many(:yammer_field_mappings).dependent(:destroy) }
    it { expect(enterprise).to have_many(:emails).dependent(:destroy) }
    it { expect(enterprise).to belong_to(:theme) }
    it { expect(enterprise).to have_many(:expenses).dependent(:destroy) }
    it { expect(enterprise).to have_many(:expense_categories).dependent(:destroy) }
    it { expect(enterprise).to have_many(:rewards).dependent(:destroy) }
    it { expect(enterprise).to have_many(:reward_actions).dependent(:destroy) }
    it { expect(enterprise).to have_many(:badges).dependent(:destroy) }
    it { expect(enterprise).to have_many(:group_categories).dependent(:destroy) }
    it { expect(enterprise).to have_many(:group_category_types).dependent(:destroy) }
    it { expect(enterprise).to have_many(:sponsors).dependent(:destroy) }
    it { expect(enterprise).to have_many(:clockwork_database_events).dependent(:destroy) }
    it { expect(enterprise).to have_many(:mentoring_interests).dependent(:destroy) }
    it { expect(enterprise).to have_many(:mentoring_requests).dependent(:destroy) }
    it { expect(enterprise).to have_many(:mentoring_sessions).dependent(:destroy) }
    it { expect(enterprise).to have_many(:mentoring_types).dependent(:destroy) }
    it { expect(enterprise).to have_many(:policy_group_templates).dependent(:destroy) }
    it { expect(enterprise).to have_many(:annual_budgets).dependent(:destroy) }

    it { expect(enterprise).to have_one(:custom_text).dependent(:destroy) }

    [:fields, :mobile_fields, :yammer_field_mappings, :theme, :reward_actions, :sponsors].each do |attribute|
      it { expect(enterprise).to accept_nested_attributes_for(attribute).allow_destroy(true) }
    end

    [:cdo_picture, :banner, :xml_sso_config, :onboarding_sponsor_media].each do |attribute|
      it { expect(enterprise).to have_attached_file(attribute) }
    end

    it { expect(enterprise).to validate_attachment_content_type(:cdo_picture).allowing('image/png', 'image/gif').rejecting('text/plain', 'text/xml') }
    it { expect(enterprise).to validate_attachment_content_type(:banner).allowing('image/png', 'image/gif').rejecting('text/plain', 'text/xml') }
    it { expect(enterprise).to validate_attachment_content_type(:xml_sso_config).allowing('text/xml').rejecting('image/png', 'image/gif') }

    it { expect(enterprise).to validate_length_of(:unit_of_expiry_age).is_at_most(191) }
    it { expect(enterprise).to validate_length_of(:redirect_email_contact).is_at_most(191) }
    it { expect(enterprise).to validate_length_of(:default_from_email_display_name).is_at_most(191) }
    it { expect(enterprise).to validate_length_of(:default_from_email_address).is_at_most(191) }
    it { expect(enterprise).to validate_length_of(:onboarding_sponsor_media_content_type).is_at_most(191) }
    it { expect(enterprise).to validate_length_of(:onboarding_sponsor_media_file_name).is_at_most(191) }
    it { expect(enterprise).to validate_length_of(:time_zone).is_at_most(191) }
    it { expect(enterprise).to validate_length_of(:xml_sso_config_content_type).is_at_most(191) }
    it { expect(enterprise).to validate_length_of(:xml_sso_config_file_name).is_at_most(191) }
    it { expect(enterprise).to validate_length_of(:privacy_statement).is_at_most(65535) }
    it { expect(enterprise).to validate_length_of(:home_message).is_at_most(65535) }
    it { expect(enterprise).to validate_length_of(:banner_content_type).is_at_most(191) }
    it { expect(enterprise).to validate_length_of(:banner_file_name).is_at_most(191) }
    it { expect(enterprise).to validate_length_of(:cdo_message).is_at_most(65535) }
    it { expect(enterprise).to validate_length_of(:cdo_picture_content_type).is_at_most(191) }
    it { expect(enterprise).to validate_length_of(:cdo_picture_file_name).is_at_most(191) }
    it { expect(enterprise).to validate_length_of(:yammer_token).is_at_most(191) }
    it { expect(enterprise).to validate_length_of(:saml_last_name_mapping).is_at_most(191) }
    it { expect(enterprise).to validate_length_of(:saml_first_name_mapping).is_at_most(191) }
    it { expect(enterprise).to validate_length_of(:idp_cert).is_at_most(65535) }
    it { expect(enterprise).to validate_length_of(:idp_slo_target_url).is_at_most(191) }
    it { expect(enterprise).to validate_length_of(:idp_sso_target_url).is_at_most(191) }
    it { expect(enterprise).to validate_length_of(:sp_entity_id).is_at_most(191) }
    it { expect(enterprise).to validate_length_of(:name).is_at_most(191) }
    it { expect(enterprise).to validate_length_of(:banner_file_name).is_at_most(191) }

    it { expect(enterprise).to allow_value('valid@email.com').for(:redirect_email_contact) }
    it { expect(enterprise).not_to allow_value('bademail.com').for(:redirect_email_contact) }
  end

  describe 'Enterprise emails' do
    let(:enterprise) { create :enterprise }
    let!(:system_email) { create :email, enterprise: enterprise }
    let!(:custom_email) { create :custom_email, enterprise: enterprise }

    context 'system emails' do
      it 'are only fetched in #emails relation' do
        expect(enterprise.emails).to include(system_email)
      end
      it 'does not include custom emails' do
        expect(enterprise.emails).to_not include(custom_email)
      end
    end

    context 'custom emails' do
      it 'is only fethed in #custom_emails relation' do
        expect(enterprise.custom_emails).to include(custom_email)
      end

      it 'does not include system emails' do
        expect(enterprise.custom_emails).to_not include(system_email)
      end
    end
  end

  describe 'Enterprise::Enumerize' do
    let!(:enterprise) { create(:enterprise) }

    it { expect(enterprise).to enumerize(:unit_of_expiry_age).in(:weeks, :months, :years).with_default(:months) }
  end

  describe 'testing callbacks' do
    let!(:new_enterprise) { build(:enterprise) }

    it 'triggers #create_elasticsearch_only_fields on before_create' do
      expect(new_enterprise).to receive(:create_elasticsearch_only_fields)
      new_enterprise.save
    end

    context '#resolve_auto_archive_state callback' do
      let!(:enterprise) { create(:enterprise, auto_archive: true) }

      it 'calls resolve_auto_archive_state callback after update' do
        enterprise.archive_switch
        expect(enterprise.auto_archive).to eq false
      end

      it 'calls resolve_auto_archive_state as after_update callback' do
        expect(enterprise).to receive(:resolve_auto_archive_state)
        enterprise.run_callbacks(:update)
      end
    end
  end

  describe '#company_video_url' do
    it 'saves the url' do
      enterprise = build_stubbed(:enterprise, company_video_url: 'https://www.youtube.com/watch?v=Y2VF8tmLFHw')
      expect(enterprise.company_video_url).to_not be(nil)
    end
  end

  describe '#custom_text' do
    context 'when enterprise does not have a custom_text' do
      let!(:enterprise) { build(:enterprise, custom_text: nil) }

      it 'create a new custom_text' do
        expect(enterprise.custom_text).to be_an_instance_of(CustomText)
      end
    end

    context 'when enterprise have a custom_text' do
      let!(:custom_text) { build_stubbed(:custom_text) }
      let!(:enterprise) { build_stubbed(:enterprise, custom_text: custom_text) }

      it 'return the custom_text' do
        expect(enterprise.custom_text).to eq custom_text
      end
    end
  end

  describe '#default_time_zone' do
    it 'returns UTC' do
      enterprise = build_stubbed(:enterprise, time_zone: nil)
      expect(enterprise.default_time_zone).to eq 'UTC'
    end

    it 'returns EST' do
      enterprise = build_stubbed(:enterprise, time_zone: 'EST')
      expect(enterprise.default_time_zone).to eq 'EST'
    end
  end

  describe '#default_user_role' do
    it 'return default_user_role_id' do
      enterprise = build(:enterprise)
      default_user_role_id = create(:user_role, default: true, enterprise: enterprise).id
      expect(enterprise.default_user_role).to eq default_user_role_id
    end
  end

  describe '#iframe_calendar_token' do
    it 'returns base64 string' do
      enterprise = create(:enterprise)
      expect(enterprise.iframe_calendar_token).not_to be_empty
    end
  end

  describe '#saml_settings' do
    it 'returns OneLogin::RubySaml::Settings object when xml config file is absent' do
      enterprise = create(:enterprise)

      expect(enterprise.xml_sso_config?).to eq(false)
      expect(enterprise.saml_settings).to be_a(OneLogin::RubySaml::Settings)
    end
  end

  describe '#match_fields' do
    let(:enterprise) { create(:enterprise) }
    let(:select_field) { create(:select_field, enterprise: enterprise, match_exclude: false) }
    let(:matchable_fields) { enterprise.fields.where(type: %w{ NumericField SelectField CheckboxField }, match_exclude: false) }

    it 'return matchable_fields' do
      expect(enterprise.match_fields(include_disabled: false)).to eq matchable_fields
    end
  end

  describe '#close_budgets_csv' do
    it 'returns csv' do
      enterprise = create(:enterprise)
      expect(enterprise.close_budgets_csv).to include('Group name,Annual budget,Leftover money,Approved budget')
    end
  end

  describe '#resources_count' do
    it 'returns count of resources' do
      enterprise = create(:enterprise)
      create_list(:resource, 4, enterprise: enterprise, folder_id: create(:folder, enterprise: enterprise).id)

      expect(enterprise.resources_count).to eq(4)
    end
  end

  describe '#generic_graphs_group_population_csv' do
    let!(:enterprise) { create(:enterprise) }
    let!(:groups) { create_list(:group, 3, enterprise: enterprise) }

    it 'returns csv' do
      expect(enterprise.generic_graphs_group_population_csv(nil, nil, nil, nil)).to include('Number of users')
    end

    it 'returns data on groups' do
      # we count the number of times :name occurs in csv as it uniquely represents name of group
      expect(enterprise.generic_graphs_group_population_csv(nil, nil, nil, nil).lines.count).to eq(4)
    end
  end

  describe '#generic_graphs_group_growth_csv' do
    let!(:enterprise) { create(:enterprise) }
    let!(:groups) { create_list(:group, 3, enterprise: enterprise) }

    it 'returns csv' do
      expect(enterprise.generic_graphs_group_growth_csv(nil, nil, nil)).to include('Group,From: All,To: All,Difference,% Change')
    end

    it 'returns data on groups' do
      # we count the number of times :name occurs in csv as it uniquely represents name of group
      expect(enterprise.generic_graphs_group_growth_csv(nil, nil, nil).lines.count).to eq(4)
    end
  end

  describe '#generic_graphs_segment_population_csv' do
    let!(:enterprise) { create(:enterprise) }
    let!(:segments) { create_list(:segment, 2, enterprise: enterprise) }

    it 'returns csv' do
      expect(enterprise.generic_graphs_segment_population_csv(enterprise.custom_text.segment)).to include('Number of users by Segment')
    end

    it 'returns data based on segments' do
      expect(enterprise.generic_graphs_segment_population_csv(enterprise.custom_text.segment).lines.count).to eq(3)
    end
  end


  describe '#generic_graphs_mentorship_csv' do
    let!(:enterprise) { create(:enterprise) }
    let!(:groups) { create_list(:group, 3, enterprise: enterprise) }

    it 'returns csv' do
      expect(enterprise.generic_graphs_mentorship_csv(nil)).to include('Number of mentors/mentees')
    end

    it 'returns data based on mentorship' do
      expect(enterprise.generic_graphs_mentorship_csv(nil).lines.count).to eq(4)
    end
  end

  describe '#generic_graphs_mentoring_sessions_csv' do
    let!(:enterprise) { create(:enterprise) }
    let!(:groups) { create_list(:group, 3, enterprise: enterprise) }

    it 'returns csv' do
      expect(enterprise.generic_graphs_mentoring_sessions_csv(nil, nil, nil)).to include('Number of mentoring sessions')
    end

    it 'returns data based on mentorship' do
      expect(enterprise.generic_graphs_mentoring_sessions_csv(nil, nil, nil).lines.count).to eq(4)
    end
  end

  describe '#generic_graphs_mentoring_interests_csv' do
    let!(:enterprise) { create(:enterprise) }
    let!(:mentoring_interests) { create_list(:mentoring_interest, 3, enterprise_id: enterprise.id) }

    it 'returns csv' do
      expect(enterprise.generic_graphs_mentoring_interests_csv).to include('Mentoring Interests')
    end

    it 'returns data based on mentoring interests' do
      expect(enterprise.generic_graphs_mentoring_interests_csv.lines.count).to eq(4)
    end
  end

  describe '#generic_graphs_non_demo_events_created_csv' do
    let!(:enterprise) { create(:enterprise) }
    let!(:groups) { create_list(:group, 3, enterprise: enterprise) }

    it 'returns csv' do
      expect(enterprise.generic_graphs_non_demo_events_created_csv(nil, nil, nil, nil)).to include('Number of events created')
    end

    it 'returns data based on non demo events created' do
      expect(enterprise.generic_graphs_non_demo_events_created_csv(nil, nil, nil, nil).lines.count).to eq(4)
    end
  end

  describe '#generic_graphs_non_demo_messages_sent_csv' do
    let!(:enterprise) { create(:enterprise) }
    let!(:groups) { create_list(:group, 3, enterprise: enterprise) }

    it 'returns csv' do
      expect(enterprise.generic_graphs_non_demo_messages_sent_csv(nil, nil, nil, nil)).to include('Number of messages sent')
    end

    it 'returns data based on non demo messages sent' do
      expect(enterprise.generic_graphs_non_demo_messages_sent_csv(nil, nil, nil, nil).lines.count).to eq(4)
    end
  end

  describe '#generic_graphs_non_demo_top_groups_by_views_csv' do
    let!(:enterprise) { create(:enterprise) }
    let!(:groups) { create_list(:group, 3, enterprise: enterprise) }

    it 'returns csv' do
      expect(enterprise.generic_graphs_non_demo_top_groups_by_views_csv('Group', nil, nil, nil)).to include('Number of view per Group')
    end

    it 'returns data based on non demo top groups viewed' do
      expect(enterprise.generic_graphs_non_demo_top_groups_by_views_csv(nil, nil, nil, nil).lines.count).to eq(4)
    end
  end

  describe '#generic_graphs_non_demo_top_folders_by_views_csv' do
    let!(:enterprise) { create(:enterprise) }
    let!(:folders) { create_list(:folder, 3, enterprise: enterprise) }

    it 'returns csv' do
      expect(enterprise.generic_graphs_non_demo_top_folders_by_views_csv(nil, nil, nil)).to include('Number of view per folder')
    end

    it 'returns data based on non demo top folders viewed' do
      expect(enterprise.generic_graphs_non_demo_top_folders_by_views_csv(nil, nil, nil).lines.count).to eq(4)
    end
  end

  describe '#generic_graphs_non_demo_top_resources_by_views_csv' do
    let!(:enterprise) { create(:enterprise) }
    let!(:group) { create(:group, enterprise: enterprise) }
    let!(:folder) { create(:folder, enterprise: enterprise, group: create(:group)) }
    let!(:resource) { create(:resource, enterprise: enterprise, folder: folder) }

    it 'returns csv' do
      expect(enterprise.generic_graphs_non_demo_top_resources_by_views_csv(nil, nil, nil)).to include('Number of view per resource')
    end

    it 'returns data based on non demo top resources by views' do
      expect(enterprise.generic_graphs_non_demo_top_resources_by_views_csv(nil, nil, nil).lines.count).to eq(1)
    end
  end

  describe '#generic_graphs_non_demo_top_news_by_views_csv' do
    let!(:enterprise) { create(:enterprise) }
    let!(:group) { create(:group, enterprise: enterprise) }
    let!(:news_link) { create(:news_link, group: group) }

    it 'returns csv' do
      expect(enterprise.generic_graphs_non_demo_top_news_by_views_csv(nil, nil, nil)).to include('Number of view per news link')
    end

    it 'returns data based on demo top news by views' do
      expect(enterprise.generic_graphs_non_demo_top_news_by_views_csv(nil, nil, nil).lines.count).to eq(1)
    end
  end

  describe '#generic_graphs_demo_events_created_csv' do
    let!(:enterprise) { create(:enterprise) }
    let!(:group) { create(:group, enterprise: enterprise) }
    let!(:initiative) { create(:initiative, owner_group: group) }

    it 'returns csv' do
      expect(enterprise.generic_graphs_demo_events_created_csv).to include('Number of events created ERG')
    end

    it 'returns data based on demo events created' do
      expect(enterprise.generic_graphs_demo_events_created_csv.lines.count).to eq(2)
    end
  end

  describe '#generic_graphs_demo_messages_sent_csv' do
    let!(:enterprise) { create(:enterprise) }
    let!(:group) { create(:group, enterprise: enterprise) }
    let!(:message) { create(:group_message, group: group) }

    it 'returns csv' do
      expect(enterprise.generic_graphs_demo_messages_sent_csv).to include('Number of messages sent ERG')
    end

    it 'returns data based on demo messages sent' do
      expect(enterprise.generic_graphs_demo_messages_sent_csv.lines.count).to eq(2)
    end
  end

  describe '#generic_graphs_demo_top_groups_by_views_csv' do
    let!(:enterprise) { create(:enterprise) }
    let!(:group) { create(:group, enterprise: enterprise) }

    it 'returns csv' do
      expect(enterprise.generic_graphs_demo_top_groups_by_views_csv('Group')).to include('Number of view per Group')
    end

    it 'returns data based on top groups by views' do
      expect(enterprise.generic_graphs_demo_top_groups_by_views_csv(nil).lines.count).to eq(2)
    end
  end

  describe '#generic_graphs_demo_top_folders_by_views_csv' do
    let!(:enterprise) { create(:enterprise) }
    let!(:group) { create(:group, enterprise: enterprise) }
    let!(:folders) { create_list(:folder, 3, group: group, enterprise: enterprise) }

    it 'returns csv' do
      expect(enterprise.generic_graphs_demo_top_folders_by_views_csv).to include('Number of view per folder')
    end

    it 'returns data based on non demo top folders viewed' do
      expect(enterprise.generic_graphs_demo_top_folders_by_views_csv.lines.count).to eq(4)
    end
  end

  describe '#generic_graphs_demo_top_resources_by_views_csv' do
    let!(:enterprise) { create(:enterprise) }
    let!(:group) { create(:group, enterprise: enterprise) }
    let!(:folder) { create(:folder, enterprise: enterprise, group: create(:group)) }
    let!(:resource) { create(:resource, enterprise: enterprise, folder: folder) }

    it 'returns csv' do
      expect(enterprise.generic_graphs_demo_top_resources_by_views_csv).to include('Number of view per resource')
    end

    it 'returns data based on non demo top resources by views' do
      expect(enterprise.generic_graphs_demo_top_resources_by_views_csv.lines.count).to eq(1)
    end
  end

  describe '#generic_graphs_demo_top_news_by_views_csv' do
    let!(:enterprise) { create(:enterprise) }
    let!(:group) { create(:group, enterprise: enterprise) }
    let!(:news_link) { create(:news_link, group: group) }

    it 'returns csv' do
      expect(enterprise.generic_graphs_demo_top_news_by_views_csv).to include('Number of view per news link')
    end

    it 'returns data based on demo top news by views' do
      expect(enterprise.generic_graphs_demo_top_news_by_views_csv.lines.count).to eq(2)
    end
  end

  describe '#logs_csv' do
    let!(:enterprise) { create(:enterprise) }

    it 'returns csv' do
      expect(enterprise.logs_csv).to include('user_id,first_name,last_name,trackable_id,trackable_type,action,enterprise_id,created_at')
    end
  end


  # re-write this for sponsor message
  xdescribe '.cdo_message_email_html' do
    context 'when cdo_message_email is not nil' do
      let(:enterprise) { build_stubbed(:enterprise, cdo_message_email: "test \r\n test") }

      it "change \r\n to br tag" do
        pending 'TODO: Move this check to Decorator, use decorator in views'
        expect(enterprise.cdo_message_email_html).to eq 'test <br> test'
      end
    end
  end

  describe '#sso_fields_to_enterprise_fields' do
    let!(:enterprise) { create :enterprise }
    let!(:age_field) { create :field, saml_attribute: 'age' }
    let!(:gender_field) { create :field, saml_attribute: 'gender' }

    let(:saml_fields) {
      {
          'age' => 23,
          'gender' => 'male',
          'department' => 'IT'
      }
    }

    before do
      enterprise.fields << age_field
      enterprise.fields << gender_field
    end

    it 'maps sso fields to existing fields' do
      mapped_fields = enterprise.sso_fields_to_enterprise_fields(saml_fields)

      expect(mapped_fields.length).to eq 2
      expect(mapped_fields).to include(age_field.id => saml_fields['age'])
      expect(mapped_fields).to include(gender_field.id => saml_fields['gender'])

      expect(mapped_fields).to_not have_key 'department'
    end
  end

  describe '#destroy_callbacks' do
    it 'removes the child objects', skip: 'this spec will pass when PR 1245 is merged to master' do
      enterprise = create(:enterprise)
      user = create(:user, enterprise: enterprise)
      field = create(:field, enterprise: enterprise)
      topic = create(:topic, enterprise: enterprise)
      segment = create(:segment, enterprise: enterprise)
      group = create(:group, enterprise: enterprise)
      folder = create(:folder, enterprise: enterprise)
      folder_share = create(:folder_share, enterprise: enterprise)
      poll = create(:poll, enterprise: enterprise)
      mobile_field = create(:mobile_field, enterprise: enterprise)
      metrics_dashboard = create(:metrics_dashboard, enterprise: enterprise)
      campaign = create(:campaign, enterprise: enterprise)
      resource = create(:resource, enterprise: enterprise)
      yammer_field_mapping = create(:yammer_field_mapping, enterprise: enterprise)
      email = create(:email, enterprise: enterprise)
      expense = create(:expense, enterprise: enterprise)
      expense_category = create(:expense_category, enterprise: enterprise)
      default_user_role = enterprise.user_roles.where(default: true).first
      policy_group_template = default_user_role.policy_group_template
      reward = create(:reward, enterprise: enterprise, responsible: user)
      reward_action = create(:reward_action, enterprise: enterprise)
      badge = create(:badge, enterprise: enterprise)
      group_category = create(:group_category, enterprise: enterprise)
      group_category_type = create(:group_category_type, enterprise: enterprise)

      enterprise.destroy!

      expect { Enterprise.find(enterprise.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { User.find(user.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Field.find(field.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Topic.find(topic.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Segment.find(segment.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Group.find(group.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Folder.find(folder.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { FolderShare.find(folder_share.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Poll.find(poll.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { MobileField.find(mobile_field.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { MetricsDashboard.find(metrics_dashboard.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Campaign.find(campaign.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { YammerFieldMapping.find(yammer_field_mapping.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Email.find(email.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Expense.find(expense.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { ExpenseCategory.find(expense_category.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { UserRole.find(default_user_role.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { PolicyGroupTemplate.find(policy_group_template.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Resource.find(resource.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Reward.find(reward.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { RewardAction.find(reward_action.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Badge.find(badge.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { GroupCategory.find(group_category.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { GroupCategoryType.find(group_category_type.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#resources_count' do
    it 'gives the correct resource count for the enterprise' do
      enterprise = create(:enterprise)
      expect(enterprise.resources_count).to eq (0)

      folder_1 = create(:folder, enterprise: enterprise)
      folder_2 = create(:folder, enterprise: enterprise)

      group_1 = create(:group, enterprise: enterprise)
      group_2 = create(:group, enterprise: enterprise)

      folder_3 = create(:folder, group: group_1)
      folder_4 = create(:folder, group: group_2)

      create_list(:resource, 5, folder: folder_1)
      create_list(:resource, 5, folder: folder_2)
      create_list(:resource, 5, folder: folder_3)
      create_list(:resource, 5, folder: folder_4)

      enterprise.reload
      expect(enterprise.resources_count).to eq (20)
    end
  end

  describe '#redirect_email_contact' do
    it 'does not save bad email' do
      enterprise = build(:enterprise, redirect_email_contact: 'fkakaodsd')
      enterprise.save

      expect(enterprise.errors.full_messages.count).to eq(1)
      expect(enterprise.errors.full_messages.first).to eq('Redirect email contact is invalid')
    end

    it 'does save email' do
      enterprise = build(:enterprise, redirect_email_contact: 'test@gmail.com')
      enterprise.save

      expect(enterprise.errors.full_messages.count).to eq(0)
    end

    it 'allows blank email' do
      enterprise = build(:enterprise, redirect_email_contact: '')
      enterprise.save

      expect(enterprise.errors.full_messages.count).to eq(0)
    end
  end

  describe '#users_csv' do
    let!(:enterprise) { create(:enterprise) }
    let!(:group_leader_role) { enterprise.user_roles.find_by(role_name: 'group_leader', role_type: 'group') }
    let!(:group_treasurer_role) { enterprise.user_roles.find_or_create_by(role_name: 'group_treasurer', role_type: 'group', priority: 2) }
    let!(:group_content_creator_role) { enterprise.user_roles.find_or_create_by(role_name: 'group_content_creator', role_type: 'group', priority: 3) }
    let!(:user_role) { enterprise.user_roles.find_by(role_name: 'user', role_type: 'user') }
    let!(:national_manager_role) { enterprise.user_roles.find_or_create_by(role_name: 'national_manager', role_type: 'user', priority: 4) }
    let!(:diversity_manager_role) { enterprise.user_roles.find_or_create_by(role_name: 'diversity_manager', role_type: 'user', priority: 5) }

    context 'return csv for group roles' do
      it 'return csv for group leader role' do
        user = create(:user, enterprise: enterprise)
        user.update(user_role: group_leader_role)
        create(:group_leader, user: user, user_role: group_leader_role)

        expect(enterprise.users_csv(2, 'group_leader'))
        .to include "#{user.first_name},#{user.last_name},#{user.email},#{user.biography},#{user.active},#{user.groups.map(&:name).join(',')}"
      end

      it 'return csv group treaurer role' do
        user = create(:user, enterprise: enterprise)
        user.update(user_role: group_treasurer_role)
        create(:group_leader, user: user, user_role: group_treasurer_role)

        expect(enterprise.users_csv(2, 'group_treasurer'))
        .to include "#{user.first_name},#{user.last_name},#{user.email},#{user.biography},#{user.active},#{user.groups.map(&:name).join(',')}"
      end

      it 'return csv group content creator role' do
        user = create(:user, enterprise: enterprise)
        user.update(user_role: group_content_creator_role)
        create(:group_leader, user: user, user_role: group_content_creator_role)

        expect(enterprise.users_csv(2, 'group_content_creator'))
        .to include "#{user.first_name},#{user.last_name},#{user.email},#{user.biography},#{user.active},#{user.groups.map(&:name).join(',')}"
      end
    end

    context 'return csv for non group roles' do
      it 'return csv for user role' do
        user = create(:user, enterprise: enterprise)
        user.update(user_role: user_role)

        expect(enterprise.users_csv(2, 'user'))
          .to include "#{user.first_name},#{user.last_name},#{user.email},#{user.biography},#{user.active},#{user.groups.map(&:name).join(',')}"
      end

      it 'return csv for national manager role' do
        user = create(:user, enterprise: enterprise)
        user.update(user_role: national_manager_role)

        expect(enterprise.users_csv(2, 'national_manager'))
          .to include "#{user.first_name},#{user.last_name},#{user.email},#{user.biography},#{user.active},#{user.groups.map(&:name).join(',')}"
      end

      it 'return csv for diversity manager role' do
        user = create(:user, enterprise: enterprise)
        user.update(user_role: diversity_manager_role)

        expect(enterprise.users_csv(2, 'diversity_manager'))
          .to include "#{user.first_name},#{user.last_name},#{user.email},#{user.biography},#{user.active},#{user.groups.map(&:name).join(',')}"
      end
    end

    describe '#archive_switch' do
      context 'when auto archive is disabled' do
        let!(:enterprise) { create(:enterprise, expiry_age_for_resources: 1) }

        it 'turn ON auto archive switch' do
          enterprise.archive_switch
          expect(enterprise.auto_archive).to eq true
        end
      end

      context 'when auto archive is enabled' do
        before { enterprise.update auto_archive: true }

        it 'turn OFF auto archive switch' do
          enterprise.archive_switch
          expect(enterprise.auto_archive).to eq false
        end
      end
    end

    describe '#consent_toggle' do
      context 'when onboarding consent is disabled' do
        let!(:enterprise) { create(:enterprise) }

        it 'turn ON consent toggle' do
          enterprise.consent_toggle
          expect(enterprise.onboarding_consent_enabled).to eq(true)
        end
      end

      context 'when onboarding consent is enabled' do
        before { enterprise.update onboarding_consent_enabled: true }

        it 'turn OFF consent toggle' do
          enterprise.consent_toggle
          expect(enterprise.onboarding_consent_enabled).to eq(false)
        end
      end
    end
  end
end
