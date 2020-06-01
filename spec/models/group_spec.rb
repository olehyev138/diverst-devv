require 'rails_helper'

ANNUAL_BUDGET = 10000
BUDGET_ITEM_AMOUNT = 5000
INITIATIVE_ESTIMATE = 2500
EXPENSE_AMOUNT = 1250

RSpec.describe Group, type: :model do
  include ActiveJob::TestHelper
  it_behaves_like 'it Defines Fields'

  describe 'test associations and validations' do
    let(:group) { build(:group) }

    it { expect(group).to validate_presence_of(:name) }

    it { expect(group).to belong_to(:enterprise) }
    it { expect(group).to belong_to(:lead_manager).class_name('User') }
    it { expect(group).to belong_to(:owner).class_name('User') }

    it { expect(group).to have_one(:news_feed).dependent(:destroy) }

    it { expect(group).to delegate_method(:news_feed_links).to(:news_feed) }
    it { expect(group).to delegate_method(:shared_news_feed_links).to(:news_feed) }

    it { expect(group).to have_many(:user_groups).dependent(:destroy) }
    it { expect(group).to have_many(:members).through(:user_groups).class_name('User').source(:user) }
    it { expect(group).to have_many(:groups_polls).dependent(:destroy) }
    it { expect(group).to have_many(:polls).through(:groups_polls) }
    it { expect(group).to have_many(:leaders).through(:group_leaders).source(:user) }
    it { expect(group).to have_many(:poll_responses).through(:polls).source(:responses) }

    it { expect(group).to have_many(:own_initiatives).class_name('Initiative').with_foreign_key('owner_group_id').dependent(:destroy) }
    it { expect(group).to have_many(:initiative_participating_groups) }
    it { expect(group).to have_many(:participating_initiatives).through(:initiative_participating_groups).source(:initiative) }
    it { expect(group).to have_many(:budgets).dependent(:destroy) }
    it { expect(group).to have_many(:messages).class_name('GroupMessage').dependent(:destroy) }
    it { expect(group).to have_many(:message_comments).through(:messages).class_name('GroupMessageComment').source(:comments) }
    it { expect(group).to have_many(:news_links).dependent(:destroy) }
    it { expect(group).to have_many(:news_link_comments).through(:news_links).class_name('NewsLinkComment').source(:comments) }
    it { expect(group).to have_many(:social_links).dependent(:destroy) }
    it { expect(group).to have_many(:invitation_segments_groups).dependent(:destroy) }
    it { expect(group).to have_many(:invitation_segments).class_name('Segment').through(:invitation_segments_groups) }
    it { expect(group).to have_many(:resources).dependent(:destroy) }
    it { expect(group).to have_many(:folders).dependent(:destroy) }
    it { expect(group).to have_many(:folder_shares).dependent(:destroy) }
    it { expect(group).to have_many(:shared_folders).through(:folder_shares).source('folder') }
    it { expect(group).to have_many(:campaigns_groups).dependent(:destroy) }
    it { expect(group).to have_many(:campaigns).through(:campaigns_groups) }
    it { expect(group).to have_many(:questions).through(:campaigns) }
    it { expect(group).to have_many(:answers).through(:questions) }
    it { expect(group).to have_many(:answer_upvotes).through(:answers).source(:votes) }
    it { expect(group).to have_many(:answer_comments).through(:answers).class_name('AnswerComment').source(:comments) }
    it { expect(group).to have_many(:outcomes).dependent(:destroy) }
    it { expect(group).to have_many(:pillars).through(:outcomes) }
    it { expect(group).to have_many(:initiatives).through(:pillars) }
    it { expect(group).to have_many(:updates).class_name('Update').dependent(:destroy) }
    it { expect(group).to have_many(:fields) }
    it { expect(group).to have_many(:survey_fields).class_name('Field').dependent(:destroy) }
    it { expect(group).to have_many(:group_leaders).dependent(:destroy) }
    it { expect(group).to have_many(:leaders).through(:group_leaders).source(:user) }
    it { expect(group).to have_many(:views).dependent(:destroy) }
    it { expect(group).to have_many(:twitter_accounts).class_name('TwitterAccount').dependent(:destroy) }
    it { expect(group).to have_many(:sponsors).dependent(:destroy) }
    it { expect(group).to have_many(:children).class_name('Group').with_foreign_key(:parent_id).dependent(:destroy) }
    it { expect(group).to belong_to(:parent).class_name('Group').with_foreign_key(:parent_id) }
    it { expect(group).to have_many(:annual_budgets).dependent(:destroy) }

    it { expect(group).to belong_to(:group_category) }
    it { expect(group).to belong_to(:group_category_type) }

    it { expect(group).to validate_uniqueness_of(:name).scoped_to(:enterprise_id) }

    # ActiveStorage
    [:logo, :banner].each do |attribute|
      it { expect(group).to have_attached_file(attribute) }
      it { expect(group).to validate_attachment_content_type(attribute, AttachmentHelper.common_image_types) }
    end

    [:outcomes, :fields, :survey_fields, :group_leaders, :sponsors].each do |attribute|
      it { expect(group).to accept_nested_attributes_for(attribute).allow_destroy(true) }
    end

    it { expect(group).to validate_presence_of(:name) }

    describe '#perform_check_for_consistency_in_category' do
      let!(:category_type1) { create(:group_category_type, name: 'New Category1') }
      let!(:categories_of_category_type1) { create_list(:group_category, 2, group_category_type_id: category_type1.id) }
      let!(:category_type2) { create(:group_category_type, name: 'New Category2') }
      let!(:categories_of_category_type2) { create_list(:group_category, 2, group_category_type_id: category_type2.id) }
      let!(:parent_group) { create(:group, parent_id: nil, group_category_id: nil, group_category_type_id: category_type1.id) }

      it 'return error message for wrong label' do
        sub_group = build(:group, parent_id: parent_group.id, group_category_id: categories_of_category_type2.first.id, group_category_type_id: category_type2.id)
        sub_group.valid?
        expect(sub_group.errors.messages[:group_category]).to eq ['wrong label for New Category1']
      end
    end

    describe '#ensure_label_consistency_between_parent_and_sub_groups' do
      let!(:category_type1) { create(:group_category_type, name: 'New Category1') }
      let!(:categories_of_category_type1) { create_list(:group_category, 2, group_category_type_id: category_type1.id) }
      let!(:category_type2) { create(:group_category_type, name: 'New Category2') }
      let!(:categories_of_category_type2) { create_list(:group_category, 2, group_category_type_id: category_type2.id) }
      let!(:parent_group) { create(:group, parent_id: nil, group_category_id: nil, group_category_type_id: nil) }
      let!(:sub_group) { create(:group, parent_id: parent_group.id, group_category_id: categories_of_category_type2.first.id, group_category_type_id: category_type2.id) }

      it 'ensure label consistency between parent and sub groups' do
        parent_group.update(group_category_id: categories_of_category_type1.first.id, group_category_type_id: category_type1.id)
        expect(parent_group.errors.messages[:group_category_id]).to eq ['chosen label inconsistent with labels of sub groups']
      end
    end

    describe '#valid_yammer_group_link?' do
      context 'with valid yammer group link' do
        let(:link) { 'https://www.yammer.com/diverst.com/#/threads/inGroup?type=in_group&feedId=6830281' }

        before { group.yammer_group_link = link }

        it 'is returns true' do
          expect(group).to be_valid
        end
      end

      context 'with invalid yammer group link' do
        let(:link) { 'https://google.com' }

        before { group.yammer_group_link = link }

        it 'returns false' do
          expect(group).to_not be_valid
        end
      end
    end

    describe '#ensure_one_level_nesting' do
      let!(:group) { create(:group) }
      let(:parent_group) { create(:group, enterprise: group.enterprise) }
      let(:child_group) { create(:group, enterprise: group.enterprise) }

      context 'with parent only' do
        before { group.parent = parent_group }

        it 'is valid' do
          expect(group).to be_valid
        end
      end

      context 'with children only' do
        before { group.children << child_group }

        it 'is valid' do
          expect(group).to be_valid
        end
      end

      context 'with both parent and children' do
        before do
          group.parent = parent_group
          group.children << child_group
        end

        it 'is invalid' do
          expect(group).to_not be_valid

          expect(group.errors.messages[:parent_id]).to include "Group can't have both parent and children"
        end
      end
    end

    describe '#ensure_not_own_parent' do
      let(:group) { build(:group) }

      it 'adds error' do
        group.update(parent: group)
        expect(group.errors.messages[:parent_id]).to include('Group cant be its own parent')
      end
    end

    describe '#ensure_not_own_child' do
      let(:group) { create(:group) }

      it 'adds error' do
        group.children << group
        expect(group.errors.messages[:parent_id]).to include('Group cant be its own parent')
      end
    end
  end

  describe '#logo_location' do
    it 'returns the actual logo location' do
      group = create(:group, logo: { io: File.open('spec/fixtures/files/verizon_logo.png'), filename: 'file.png' })

      expect(group.logo_location).to_not be nil
    end
  end

  describe '#banner_location' do
    it 'returns the actual banner location' do
      group = create(:group, banner: { io: File.open('spec/fixtures/files/verizon_logo.png'), filename: 'file.png' })

      expect(group.banner_location).to_not be nil
    end
  end

  describe 'index' do
    it 'gets all parents' do
      enterprise = create(:enterprise)
      enterprise_2 = create(:enterprise)
      user = create(:user, enterprise: enterprise)

      group_1 = create(:group, enterprise: enterprise)
      create(:group, enterprise: enterprise, parent_id: group_1.id)
      create(:group, enterprise: enterprise_2)

      diverst_request = Request.create_request(user)

      # gets all groups for enterprise
      page = Group.index(diverst_request, {})
      expect(page.total).to eq(2)

      # get only parent groups for enterprise
      page = Group.index(diverst_request, { parent_id: 'null' })
      expect(page.total).to eq(1)
    end

    it 'returns the correct groups by scope' do
      enterprise_1 = create(:enterprise)
      create_list(:group, 10, enterprise: enterprise_1)

      enterprise_2 = create(:enterprise)
      create_list(:group, 10, enterprise: enterprise_2, private: false)
      create(:group, enterprise: enterprise_2, private: true)
      user = create(:user, enterprise: enterprise_2)
      response = Group.index(Request.create_request(user), { query_scopes: ['is_private'] })
      expect(response.total).to eq(1)
    end
  end

  describe '#build' do
    it 'sets the logo and banner for group from url when creating group' do
      user = create(:user)
      file = File.open('spec/fixtures/files/verizon_logo.png')
      request = Request.create_request(user)
      payload = { group: { name: 'Save', enterprise_id: user.enterprise_id, banner: file, logo: file } }
      params = ActionController::Parameters.new(payload)
      created = Group.build(request, params.permit!)

      expect(created.banner.presence).to_not be nil
      expect(created.logo.presence).to_not be nil
    end
  end

  describe '#yammer_group_id' do
    let(:group) { build_stubbed(:group) }

    subject { group.yammer_group_id }

    context 'with link' do
      context 'with correct link' do
        let(:link) { 'https://www.yammer.com/diverst.com/#/threads/inGroup?type=in_group&feedId=6830281' }

        before { group.yammer_group_link = link }
        it 'returns correct group id' do
          expect(subject).to eq 6830281
        end
      end

      context 'with incorrect link' do
        let(:link) { 'https://google.com' }

        before { group.yammer_group_link = link }

        it 'returns nil' do
          expect(subject).to be_nil
        end
      end
    end

    context 'without yammer link' do
      let(:link) { nil }
      before { group.yammer_group_link = link }

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
  end

  describe '#accept_user_to_group' do
    let!(:enterprise) { create(:enterprise) }
    let!(:user) { create(:user, enterprise: enterprise) }
    let!(:group) { create(:group, enterprise: enterprise) }

    let(:user_id) { user.id }
    subject { group.accept_user_to_group(user.id) }

    context 'with not existent user' do
      let!(:user_id) { nil }

      it 'returns false' do
        expect(subject).to eq false
      end
    end

    context 'with existing user' do
      context 'when user is not a group member' do
        it 'returns false' do
          expect(subject).to eq false
        end
      end

      context 'when user is a group member' do
        before { user.groups << group }

        shared_examples 'makes user an active member' do
          it 'returns true' do
            expect(subject).to eq true
          end

          it 'updates user model attribute' do
            subject

            user.reload
            expect(user.active_group_member?(group.id)).to eq true
          end
        end

        context 'when user is not an active member' do
          it_behaves_like 'makes user an active member'
        end

        context 'when user is already an active member' do
          it_behaves_like 'makes user an active member'
        end
      end
    end
  end

  describe '#survey_answers_csv' do
    it 'returns a csv file' do
      field = build(:field, field_type: 'group_survey')
      group = create(:group, survey_fields: [field])
      user = create(:user)
      user_group = create(:user_group, user: user, group: group, data: '{"13":"test"}')
      user_group[field] = 'test'

      csv = CSV.generate do |file|
        file << ['user_id', 'user_email', 'user_first_name', 'user_last_name'].concat(group.survey_fields.map(&:title))
        file << [user.id, user.email, user.first_name, user.last_name, field.csv_value(user_group[field])]
      end

      result = group.survey_answers_csv
      expect(result).to eq(csv)
    end
  end

  describe 'members fetching by type' do
    let(:enterprise) { create :enterprise }

    context 'with disabled pending members setting' do
      let!(:group) { create :group, enterprise: enterprise }
      let!(:active_user) { create :user, enterprise: enterprise, active: true }
      let!(:inactive_user) { create :user, enterprise: enterprise, active: false }
      let!(:pending_user) { create :user, enterprise: enterprise }

      before do
        group.members << active_user
        group.members << pending_user
      end

      describe '#active_members' do
        subject { group.active_members }

        it 'contain all group users' do
          expect(subject).to include active_user
          expect(subject).to include pending_user
        end
      end

      describe '#pending_members' do
        subject { group.pending_members }

        it 'contains no user' do
          expect(subject).to_not include pending_user
          expect(subject).to_not include active_user
        end
      end
    end

    context 'with enabled pending members setting' do
      let!(:group) { create :group, enterprise: enterprise, pending_users: 'enabled' }
      let!(:active_user) { create :user, enterprise: enterprise, active: true }
      let!(:inactive_user) { create :user, enterprise: enterprise, active: false }
      let!(:pending_user) { create :user, enterprise: enterprise }

      before do
        group.members << active_user
        group.members << pending_user

        group.accept_user_to_group(active_user.id)
      end

      describe '#active_members' do
        subject { group.active_members }

        it 'contains active user' do
          expect(subject).to include active_user
        end

        it 'does not contains pending user' do
          expect(subject).to_not include [pending_user, inactive_user]
        end
      end

      describe '#pending_members' do
        subject { group.pending_members }

        it 'contains pending user' do
          expect(subject).to include pending_user
        end

        it 'does not contains active user' do
          expect(subject).to_not include [active_user, inactive_user]
        end
      end
    end
  end

  describe '#Enumerize' do
    let(:group) { build(:group) }

    it { expect(group).to enumerize(:layout).in(:layout_0, :layout_1, :layout_2).with_default(:layout_0) }
    it { expect(group).to enumerize(:pending_users).in(:enabled, :disabled).with_default(:disabled) }
    it { expect(group).to enumerize(:members_visibility).in(:public, :group, :leaders_only).with_default(:managers_only) }
    it { expect(group).to enumerize(:event_attendance_visibility).in(:public, :group, :leaders_only).with_default(:managers_only) }
    it { expect(group).to enumerize(:messages_visibility).in(:public, :group, :leaders_only).with_default(:managers_only) }
    it { expect(group).to enumerize(:latest_news_visibility).in(:public, :group, :leaders_only).with_default(:leaders_only) }
    it { expect(group).to enumerize(:upcoming_events_visibility).in(:public, :group, :leaders_only, :non_member).with_default(:leaders_only) }
    it { expect(group).to enumerize(:unit_of_expiry_age).in(:weeks, :months, :years).with_default(:months) }
  end

  describe 'test scopes' do
    let!(:enterprise) { create(:enterprise) }
    let!(:groups) { create_list(:group, 3, enterprise: enterprise) }

    context 'Group::by_enterprise' do
      it 'returns groups belonging to the enterprise' do
        expect(Group.by_enterprise(enterprise).ids.sort).to eq(groups.pluck(:id).sort)
      end
    end

    context 'Group::top_participants' do
      before do
        groups.first.update(total_weekly_points: 10)
        groups.second.update(total_weekly_points: 8)
      end

      it 'returns groups ordered in descending order of total_weekly_points' do
        expect(Group.top_participants(2)).to eq([groups.first, groups.second])
      end
    end

    context 'Group::is_private' do
      let!(:private_group) { create(:group, private: true) }

      it 'returns private group' do
        expect(Group.is_private).to eq([private_group])
      end
    end

    context 'Group::non_private' do
      it 'returns non_private groups' do
        expect(Group.non_private.ids.sort).to eq(groups.pluck(:id).sort)
      end
    end

    context 'Group::all_parents' do
      it 'returns all parent groups' do
        expect(Group.all_parents.ids.sort).to eq(groups.pluck(:id).sort)
      end
    end

    context 'Group::all_children' do
      before { groups.second.update(parent_id: groups.first.id) }

      it 'returns all child groups' do
        expect(Group.all_children).to eq([groups.second])
      end
    end
  end

  describe '#is_parent_group?' do
    let(:group) { create(:group) }

    it 'returns false if either parent is absent or no children exists' do
      expect(group.is_parent_group?).to eq(false)
    end

    it 'returns true if both parent is present and children exists' do
      create(:group, parent_id: group.id)
      expect(group.is_parent_group?).to eq(true)
    end
  end

  describe '#is_sub_group?' do
    let(:group) { create(:group) }

    it 'returns false if parent is absent' do
      expect(group.is_sub_group?).to eq(false)
    end

    it 'returns true if parent is present' do
      group1 = create(:group, parent_id: group.id)
      expect(group1.is_sub_group?).to eq(true)
    end
  end

  describe '#is_standard_group?' do
    let(:group) { create(:group) }

    it 'returns false if either parent is absent and no children exists' do
      expect(group.is_standard_group?).to eq(true)
    end

    it 'returns true if both parent is present or no children exists' do
      create(:group, parent_id: group.id)
      expect(group.is_standard_group?).to eq(false)
    end
  end

  describe '#capitalize_name' do
    it 'returns capitalize group name' do
      group = create(:group, name: 'new group')
      expect(group.capitalize_name).to eq('New Group')
    end
  end

  describe '#managers' do
    it 'returns an array with nil' do
      group = build(:group)
      expect(group.managers.length).to eq(1)
      expect(group.managers[0]).to be_nil
    end

    it 'returns an array with user' do
      user = build(:user)
      group = build(:group, owner: user)

      expect(group.managers.length).to eq(1)
      expect(group.managers[0]).to be(user)
    end

    it 'returns an array with owner and leaders' do
      user = create(:user)
      group = create(:group, enterprise: user.enterprise, owner: user)
      create(:user_group, user: user, group: group, accepted_member: true)
      create(:group_leader, group: group, user: user)

      expect(group.managers.length).to eq(2)
    end
  end

  describe '#calendar_color' do
    it 'returns cccccc' do
      group = build(:group)
      expect(group.calendar_color).to eq('cccccc')
    end

    it 'returns theme primary_color' do
      theme = build_stubbed(:theme)
      enterprise = build_stubbed(:enterprise, theme: theme)
      group = build_stubbed(:group, enterprise: enterprise)
      expect(group.calendar_color).to eq(enterprise.theme.primary_color)
    end
  end

  describe '#approved' do
    it 'returns 0 with annual budget' do
      group = build(:group)
      group.create_annual_budget
      expect(group.annual_budget_approved).to eq(0)
    end

    it 'returns nil without annual budget' do
      group = build(:group)
      expect(group.annual_budget_approved).to eq(nil)
    end
    it 'returns approved budget' do
      group = create(:group, annual_budget: 2000)
      annual_budget = create(:annual_budget, group: group, closed: false, amount: 2000)
      budget = create(:budget, group: group, is_approved: true, annual_budget_id: annual_budget.id)
      budget.budget_items.update_all(estimated_amount: 500, is_done: true)

      expect(group.annual_budget_approved).to eq 1500
    end
  end

  describe '#available' do
    it 'returns 0 with annual budget' do
      group = build(:group)
      group.create_annual_budget
      expect(group.annual_budget_available).to eq(0)
    end

    it 'returns nil without annual budget' do
      group = build(:group)
      expect(group.annual_budget_available).to eq(nil)
    end

    it 'returns available budget' do
      group = create(:group, annual_budget: ANNUAL_BUDGET)
      budget = create(:budget, group: group, is_approved: true)
      create(:budget_item, budget: budget, estimated_amount: 5000)

      expect(group.annual_budget_available).to eq(group.annual_budget_approved - group.annual_budget_expenses)
    end
  end


  describe '#expenses' do
    it 'returns 0 with annual expenses' do
      group = build(:group)
      group.create_annual_budget
      expect(group.annual_budget_expenses).to eq(0)
    end

    it 'returns nil without annual budget' do
      group = build(:group)
      expect(group.annual_budget_expenses).to eq(nil)
    end

    it 'returns expenses budget' do
      group = create(:group)
      annual_budget = create(:annual_budget, group: group, closed: false, amount: 10000)
      budget = create(:approved_budget, annual_budget_id: annual_budget.id)
      initiative = create(:initiative, owner_group: group,
                                       estimated_funding: budget.budget_items.first.available_amount,
                                       budget_item_id: budget.budget_items.first.id)
      expense = create(:initiative_expense, initiative_id: initiative.id, amount: 10)
      initiative.finish_expenses!

      expect(group.annual_budget_expenses).to eq 10
    end
  end

  describe '#news_feed' do
    it 'returns news_feed' do
      group = create(:group)
      expect(group.news_feed).to_not be(nil)
    end

    it 'returns news_feed event after destroy' do
      group = create(:group)

      expect(group.news_feed).to_not be(nil)
      group.news_feed.destroy

      expect(group.news_feed).to_not be(nil)
    end
  end

  describe '#parent' do
    it 'returns nil' do
      group = build(:group)
      expect(group.parent).to be(nil)
    end

    it 'returns parent' do
      group_1 = build(:group)
      group_2 = build(:group, parent: group_1)

      expect(group_2.parent).to_not be(nil)
      expect(group_2.parent).to eq(group_1)
    end
  end

  describe '#children' do
    it 'returns empty array' do
      group = build(:group)
      expect(group.children.length).to eq(0)
    end

    it 'returns 1 child' do
      group_1 = create(:group)
      group_2 = create(:group, parent: group_1)

      expect(group_1.children).to include(group_2)
    end
  end

  describe '#avg_members_per_group' do
    it 'returns 2' do
      enterprise = create(:enterprise)
      user_1 = create(:user, enterprise: enterprise)
      user_2 = create(:user, enterprise: enterprise)
      group_1 = create(:group, enterprise: enterprise)
      group_2 = create(:group, enterprise: enterprise)
      create(:user_group, user: user_1, group: group_1)
      create(:user_group, user: user_2, group: group_1)
      create(:user_group, user: user_1, group: group_2)
      create(:user_group, user: user_2, group: group_2)

      average = Group.avg_members_per_group(enterprise: enterprise)
      expect(average).to eq(2)
    end
  end

  describe '#accept_pending_members' do
    it 'accepts pending members' do
      enterprise = create(:enterprise)
      user_1 = create(:user, enterprise: enterprise)
      user_2 = create(:user, enterprise: enterprise)
      group = create(:group, enterprise: enterprise, pending_users: 'enabled')
      create(:user_group, user: user_1, group: group, accepted_member: false)
      create(:user_group, user: user_2, group: group, accepted_member: false)

      group.accept_pending_members

      expect(group.user_groups.pluck(:accepted_member)).to all(be true)
    end
  end

  describe '#pending_members_enabled?' do
    context 'with pending members enabled' do
      let(:group) { create(:group, pending_users: 'enabled') }

      it 'returns true' do
        expect(group.pending_members_enabled?).to eq(true)
      end
    end

    context 'with pending members disabled' do
      let(:group) { create(:group, pending_users: 'disabled') }

      it 'returns false' do
        expect(group.pending_members_enabled?).to eq(false)
      end
    end
  end

  describe '#file_safe_name' do
    it 'returns file_safe_name' do
      group = build(:group, name: 'test name')
      expect(group.file_safe_name).to eq('test_name')
    end
  end

  describe '#logo_expiring_thumb' do
    let(:group) { build(:group) }

    it 'returns nil when logo is blank' do
      expect(group.logo_expiring_thumb).to eq(nil)
    end
  end

  describe '#possible_participating_groups' do
    it 'returns possible_participating_groups' do
      enterprise = create(:enterprise)
      group_1 = create(:group, enterprise: enterprise)
      create(:group, enterprise: enterprise)
      expect(group_1.possible_participating_groups.length).to eq(1)
    end
  end

  describe '#highcharts_history' do
    it 'returns highcharts_history' do
      group = create(:group)
      field = create(:field)
      create(:update, updatable: group, report_date: 30.days.ago)
      data = group.highcharts_history(field: field)
      expect(data.length).to eq(1)
    end
  end

  describe '#title_with_leftover_amount' do
    it 'returns title_with_leftover_amount' do
      group = create(:group)
      annual_budget = create(:annual_budget, group: group, amount: ANNUAL_BUDGET)
      budget = create(:approved_budget, :zero_budget, annual_budget: annual_budget)
      budget_item = budget.budget_items.first
      budget_item.update(estimated_amount: BUDGET_ITEM_AMOUNT)
      initiative = create(:initiative, owner_group: group, budget_item: budget.budget_items.first, estimated_funding: INITIATIVE_ESTIMATE)
      build(:initiative_expense, initiative: initiative, amount: EXPENSE_AMOUNT)


      expect(group.title_with_leftover_amount).to eq("Create event from #{group.name} leftover ($%.2f)" % (BUDGET_ITEM_AMOUNT - INITIATIVE_ESTIMATE).round(2))
    end
  end

  describe '#sync_yammer_users' do
    it 'subscribe yammer users to group' do
      yammer = double('YammerClient')
      allow(YammerClient).to receive(:new).and_return(yammer)
      allow(yammer).to receive(:user_with_email).and_return({ 'id' => 1, 'yammer_token' => nil })
      allow(yammer).to receive(:token_for_user).and_return({ 'token' => 'token' })
      allow(yammer).to receive(:subscribe_to_group)

      group = build(:group)
      user = build(:user)
      create(:user_group, user: user, group: group)

      group.sync_yammer_users

      expect(yammer).to have_received(:subscribe_to_group)
    end
  end

  describe '#pending_comments_count' do
    it 'returns 0' do
      group = build(:group)
      expect(group.pending_comments_count).to eq(0)
    end

    it 'returns 1' do
      group = create(:group)
      group_message = build(:group_message, group: group)
      create(:group_message_comment, message: group_message, approved: false)
      expect(group.pending_comments_count).to eq(1)
    end

    it 'returns 2' do
      group = create(:group)
      group_message = build(:group_message, group: group)
      create(:group_message_comment, message: group_message, approved: false)
      news_link = build(:news_link, group: group)
      create(:news_link_comment, news_link: news_link, approved: false)
      expect(group.pending_comments_count).to eq(2)
    end

    it 'returns 3' do
      group = create(:group)
      # group message
      group_message = build(:group_message, group: group)
      create(:group_message_comment, message: group_message, approved: false)
      # news link
      news_link = build(:news_link, group: group)
      create(:news_link_comment, news_link: news_link, approved: false)
      # campaign
      campaign = create(:campaign)
      create(:campaigns_group, group: group, campaign: campaign)
      question = build(:question, campaign: campaign)
      answer = build(:answer, question: question)
      create(:answer_comment, answer: answer, approved: false)

      expect(group.pending_comments_count).to eq(3)
    end
  end

  describe '#pending_posts_count' do
    let!(:group) { create(:group) }
    let!(:news_links) { create_list(:news_link, 2, group_id: group.id) }
    let!(:messages) { create_list(:group_message, 2, group_id: group.id) }
    let!(:social_links) { create_list(:social_link, 2, group_id: group.id) }

    before { NewsFeedLink.update_all(approved: false) }

    it 'returns pending_posts_count' do
      expect(group.pending_posts_count).to eq(6)
    end
  end

  describe '#valid_yammer_group_link?' do
    it 'has a valid link' do
      group = build(:group, yammer_group_link: 'https://www.yammer.com/test.com/#/threads/inGroup?type=in_group&feedId=1234567')
      expect(group.valid_yammer_group_link?).to be(true)
    end

    it 'does not have a valid link' do
      group = build(:group, yammer_group_link: 'https://www.yammer.com/test.com/#/threads/inGroup?type')
      expect(group.valid_yammer_group_link?).to be(false)
      expect(group.errors.full_messages.length).to eq(1)
      expect(group.errors.full_messages.first).to eq('Yammer group link this is not a yammer group link')
    end
  end

  describe '#company_video_url' do
    it 'saves the url' do
      group = build(:group, company_video_url: 'https://www.youtube.com/watch?v=Y2VF8tmLFHw')
      expect(group.company_video_url).to_not be(nil)
    end
  end

  describe '#create_yammer_group' do
    it 'creates the group in yammer and syncs the members' do
      yammer = double('YammerClient')
      allow(YammerClient).to receive(:new).and_return(yammer)
      allow(yammer).to receive(:create_group).and_return({ 'id' => 1 })
      allow(SyncYammerGroupJob).to receive(:perform_later)

      enterprise = build(:enterprise, yammer_token: 'token')
      group = create(:group, enterprise: enterprise, yammer_create_group: true, yammer_group_created: false)

      expect(yammer).to have_received(:create_group)
      expect(group.yammer_group_created).to be(true)
      expect(group.yammer_id).to eq(1)
      expect(SyncYammerGroupJob).to have_received(:perform_later)
    end
  end

  describe '#membership_list_csv' do
    let(:group) { create(:group) }

    it 'returns csv' do
      expect(group.membership_list_csv([])).to include('first_name,last_name,email_address')
    end

    it 'returns number of members in csv' do
      create_list(:user_group, 3, group_id: group.id)
      expect(group.membership_list_csv(group.members)).to include("total,,#{group.members.count}\n")
    end
  end

  describe '#budgets_csv' do
    let(:group) { create(:group) }

    it 'returns csv' do
      expect(group.budgets_csv).to include('Requested amount,Available amount,Status,Requested at,# of events,Description')
    end
  end

  describe '#update_all_elasticsearch_members' do
    before { pending }
    it 'updates the users in elasticsearch' do
      pending
      group = create(:group)
      user = create(:user)
      create(:user_group, group: group, user: user)

      perform_enqueued_jobs do
        expect_any_instance_of(IndexElasticsearchJob).to receive(:perform)

        group.name = 'testing elasticsearch'
        group.save!
      end
    end
  end

  describe '#set_default_group_contact' do
    it 'updates contact email if group leader is default_group_contact' do
      user = create(:user)
      group = create(:group, enterprise: user.enterprise)
      create(:user_group, user: user, group: group, accepted_member: true)

      group_leader = create(:group_leader, group: group, user: user, default_group_contact: true)
      group_leader = group.group_leaders.find_by(default_group_contact: true)&.user


      expect(group.contact_email).to eq group_leader&.email
    end

    it 'sets contact email to nil if group leader is not set.' do
      user = create(:user)
      group = create(:group, enterprise: user.enterprise)
      create(:user_group, user: user, group: group, accepted_member: true)

      create(:group_leader, group: group, user: user, default_group_contact: false)

      expect(group.contact_email).to eq nil
    end
  end

  describe '#total_views' do
    it 'returns 10' do
      group = create(:group)
      create_list(:view, 10, group: group)

      expect(group.total_views).to eq(10)
    end
  end

  describe '#destroy_callbacks' do
    it 'removes the child objects' do
      group = create(:group, annual_budget: 10000)
      news_feed = create(:news_feed, group: group)
      user_group = create(:user_group, group: group)
      groups_poll = create(:groups_poll, group: group)
      initiative = create(:initiative, owner_group_id: group.id)
      budget = create(:budget, group: group)
      group_message = create(:group_message, group: group)
      news_link = create(:news_link, group: group)
      social_link = create(:social_link, group: group)
      invitation_segments_group = create(:invitation_segments_group, group: group)
      resource = create(:resource, group: group)
      folder = create(:folder, group: group)
      folder_share = create(:folder_share, group: group)
      campaigns_group = create(:campaigns_group, group: group)
      outcome = create(:outcome, group: group)
      group_update = create(:update, updatable: group)
      field = create(:field, field_definer: group, field_type: 'regular')
      survey_field = create(:field, field_definer: group, field_type: 'group_survey')
      user = create(:user, enterprise: group.enterprise)
      create(:user_group, user: user, group: group, accepted_member: true)
      group_leader = create(:group_leader, group: group, user: user)
      child = create(:group, parent: group)

      group.fields.reload
      group.survey_fields.reload

      group.destroy!

      expect { Group.find(group.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { NewsFeed.find(news_feed.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { UserGroup.find(user_group.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { GroupsPoll.find(groups_poll.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Initiative.find(initiative.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Budget.find(budget.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { GroupMessage.find(group_message.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { NewsLink.find(news_link.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { SocialLink.find(social_link.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { InvitationSegmentsGroup.find(invitation_segments_group.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Resource.find(resource.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Folder.find(folder.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { FolderShare.find(folder_share.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { CampaignsGroup.find(campaigns_group.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Outcome.find(outcome.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Update.find(group_update.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Field.find(field.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Field.find(survey_field.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { GroupLeader.find(group_leader.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Group.find(child.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#default_mentor_group' do
    it "ensures there aren't duplicate default_mentor_groups for enterprises" do
      enterprise_1 = create(:enterprise)
      group_1 = create(:group, enterprise: enterprise_1)
      group_2 = create(:group, enterprise: enterprise_1)

      enterprise_2 = create(:enterprise)
      group_3 = create(:group, enterprise: enterprise_2)
      group_4 = create(:group, enterprise: enterprise_2)

      group_1.default_mentor_group = true
      group_1.save!

      expect(group_1.valid?).to be true

      group_2.default_mentor_group = true
      expect(group_2.valid?).to be false
      expect(group_2.errors.full_messages.first).to eq ('Default mentor group has already been taken')

      group_3.default_mentor_group = true
      group_3.save!

      expect(group_3.valid?).to be true

      group_4.default_mentor_group = true
      expect(group_4.valid?).to be false
    end
  end

  describe '#name' do
    it 'validates group cannot have duplicate names per enterprise' do
      enterprise = create(:enterprise)
      enterprise_2 = create(:enterprise)
      group = create(:group, enterprise: enterprise)
      group_2 = build(:group, name: group.name, enterprise: enterprise)
      group_3 = create(:group, name: group.name, enterprise: enterprise_2)

      # validate that the first group is valid
      expect(group.valid?).to be(true)

      # validate that the second group is not valid since a group cannot have
      # the same name as another group in the same enterprise
      expect(group_2.valid?).to_not be(true)

      # validate that the third group is valid since a group can have the same
      # as another group in another enterprise
      expect(group_3.valid?).to be(true)
    end
  end

  describe '#archive_switch' do
    let!(:enterprise) { create(:enterprise) }
    let!(:group) { create(:group, enterprise: enterprise, expiry_age_for_news: 1) }

    it 'turn on auto archive switch' do
      group.archive_switch
      expect(group.auto_archive).to eq true
    end

    it 'turn off auto archive switch' do
      group.update auto_archive: true
      group.archive_switch
      expect(group.auto_archive).to eq false
    end
  end

  describe '#resolve_auto_archive_state callback' do
    let!(:enterprise) { create(:enterprise) }
    let!(:group) { create(:group, enterprise: enterprise, auto_archive: true) }

    it 'calls resolve_auto_archive_state callback after update' do
      group.archive_switch
      expect(group.auto_archive).to eq false
    end

    it 'calls resolve_auto_archive_state as after_update callback' do
      expect(group).to receive(:resolve_auto_archive_state)
      group.run_callbacks(:update)
    end
  end

  describe '#membership_list_csv' do
    it 'returns correct headers when mentorship_module_enabled is false' do
      enterprise = create(:enterprise, mentorship_module_enabled: false)
      group = create(:group, enterprise: enterprise)
      csv = group.membership_list_csv(group.members)
      expect(csv).to eq("first_name,last_name,email_address\ntotal,,0\n")
    end

    it 'returns correct headers when mentorship_module_enabled is true' do
      enterprise = create(:enterprise, mentorship_module_enabled: true)
      group = create(:group, enterprise: enterprise)
      csv = group.membership_list_csv(group.members)
      expect(csv).to eq("first_name,last_name,email_address,mentor,mentee\ntotal,,0\n")
    end
  end
end
