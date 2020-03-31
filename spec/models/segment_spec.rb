require 'rails_helper'

RSpec.describe Segment, type: :model do
  describe 'when validating' do
    let(:segment) { build(:segment) }

    it { expect(segment).to belong_to(:parent).class_name('Segment').with_foreign_key(:parent_id) }
    it { expect(segment).to have_many(:children).class_name('Segment').with_foreign_key(:parent_id).dependent(:destroy) }

    it { expect(segment).to belong_to(:enterprise).counter_cache(true) }
    it { expect(segment).to belong_to(:owner).class_name('User') }

    # Rules
    it { expect(segment).to have_many(:field_rules).class_name('SegmentFieldRule').dependent(:destroy) }
    it { expect(segment).to have_many(:order_rules).class_name('SegmentOrderRule').dependent(:destroy) }
    it { expect(segment).to have_many(:group_rules).class_name('SegmentGroupScopeRule').dependent(:destroy) }

    it { expect(segment).to have_many(:users_segments).dependent(:destroy) }
    it { expect(segment).to have_many(:members).through(:users_segments).class_name('User').source(:user).dependent(:destroy) }
    it { expect(segment).to have_many(:polls_segments).dependent(:destroy) }
    it { expect(segment).to have_many(:polls).through(:polls_segments) }
    it { expect(segment).to have_many(:group_messages_segments).dependent(:destroy) }
    it { expect(segment).to have_many(:group_messages).through(:group_messages_segments) }
    it { expect(segment).to have_many(:invitation_segments_groups) }
    it { expect(segment).to have_many(:groups).through(:invitation_segments_groups).inverse_of(:invitation_segments) }
    it { expect(segment).to have_many(:initiative_segments).dependent(:destroy) }
    it { expect(segment).to have_many(:initiatives).through(:initiative_segments) }

    it { expect(segment).to validate_presence_of(:name) }
    it { expect(segment).to validate_presence_of(:enterprise) }
    it { expect(segment).to validate_presence_of(:active_users_filter) }

    # Nested rule attributes
    it { expect(segment).to accept_nested_attributes_for(:field_rules).allow_destroy(true) }
    it { expect(segment).to accept_nested_attributes_for(:order_rules).allow_destroy(true) }
    it { expect(segment).to accept_nested_attributes_for(:group_rules).allow_destroy(true) }
  end

  describe 'test validations' do
    let!(:enterprise) { create(:enterprise) }
    let!(:segment) { create(:segment, name: 'Females', enterprise: enterprise) }

    it { expect(segment).to validate_uniqueness_of(:name).scoped_to(:enterprise_id) }
    it { expect(segment).to validate_length_of(:active_users_filter).is_at_most(191) }
    it { expect(segment).to validate_length_of(:name).is_at_most(191) }
    it { expect(segment).to validate_presence_of(:name) }
    it { expect(segment).to validate_presence_of(:active_users_filter) }
    it { expect(segment).to validate_presence_of(:enterprise) }

    context 'raise error' do
      it 'when segment with the same name is created' do
        expect { create(:segment, name: 'Females', enterprise: enterprise) }.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end

  describe 'associations' do
    it 'creates parent segment and children' do
      parent = create(:segment)

      3.times do
        child = create(:segment)
        parent.children << child
        parent.save
      end

      expect(parent.children.count).to eq(3)

      parent.children.each do |sub_segment|
        expect(sub_segment.parent_id).to eq(parent.id)
      end
    end
  end

  describe 'when describing callbacks' do
    it 'should reindex users on elasticsearch after create', skip: true do
      segment = build(:segment)
      TestAfterCommit.with_commits(true) do
        expect(RebuildElasticsearchIndexJob).to receive(:perform_later).with(
          model_name: 'User',
          enterprise: segment.enterprise
        )
        segment.save
      end
    end

    it 'should reindex users on elasticsearch after update', skip: true do
      segment = create(:segment)
      TestAfterCommit.with_commits(true) do
        expect(RebuildElasticsearchIndexJob).to receive(:perform_later).with(
          model_name: 'User',
          enterprise: segment.enterprise
        )
        segment.update(name: 'new segment')
      end
    end

    it 'should reindex users on elasticsearch after destroy', skip: true do
      segment = create(:segment)
      TestAfterCommit.with_commits(true) do
        expect(RebuildElasticsearchIndexJob).to receive(:perform_later).with(
          model_name: 'User',
          enterprise: segment.enterprise
        )
        segment.destroy
      end
    end
  end

  describe 'test scopes' do
    describe '.all_parents' do
      let!(:segment) { create(:segment, parent_id: nil) }

      it 'returns parent segment' do
        expect(described_class.all_parents).to eq([segment])
      end
    end

    describe '.all_children' do
      let!(:segment) { create(:segment, parent_id: create(:segment).id) }

      it 'return child segment' do
        expect(described_class.all_children).to eq([segment])
      end
    end
  end

  describe '#ordered_members' do
    let!(:segment) { create(:segment) }
    let!(:order_rules) { create_list(:segment_order_rule, 4, segment_id: segment.id) }
    let!(:users) { create_list(:user, 3) }
    let!(:members) do
      users.each { |user| create(:users_segment, user_id: user.id, segment_id: segment.id) }
    end

    it 'returns ordered members' do
      expect(segment.ordered_members).to eq(members)
    end
  end

  describe '#rules' do
    let!(:segment) { create(:segment) }
    let!(:rules) { create_list(:segment_field_rule, 3, segment_id: segment.id) }

    it 'returns field_rules for segment' do
      expect(segment.rules).to eq(rules)
    end
  end

  describe '#all_rules_count' do
    let!(:segment) { create(:segment) }
    let!(:segment_field_rule) { create(:segment_field_rule, segment_id: segment.id) }
    let!(:order_rule) { create(:segment_order_rule, segment_id: segment.id) }
    let!(:group_rule) { create(:segment_group_scope_rule, segment_id: segment.id) }

    it 'returns sum of rules count' do
      expect(segment.all_rules_count).to eq(3)
    end
  end

  describe '#apply_field_rules' do
    let!(:segment) { create(:segment, active_users_filter: 'only_inactive') }
    let!(:active_users) { create_list(:user, 3, enterprise: segment.enterprise) }
    let!(:inactive_users) { create_list(:user, 2, enterprise: segment.enterprise, active: false) }
    let!(:users) { User.where(id: (active_users + inactive_users).map(&:id)) }
    let!(:members) do
      users.each { |user| create(:users_segment, user_id: user.id, segment_id: segment.id) }
    end

    xit 'returns inactive users' do
      # TODO: active isnt a field rule

      expect(segment.apply_field_rules(users)).to eq(inactive_users)
    end
  end

  describe '#apply_group_rules' do
    let!(:segment) { create(:segment) }
    let!(:group) { create(:group, enterprise: segment.enterprise) }
    let!(:users) { create_list(:user, 3, enterprise: segment.enterprise) }
    let!(:group_rules) { create_list(:segment_group_scope_rule, 2, segment_id: create(:segment, enterprise: segment.enterprise).id, operator: 0) }

    before { users.each { |user| create(:user_group, user_id: user.id, group_id: group.id) } }

    it 'returns users' do
      expect(segment.apply_group_rules(users)).to eq(users)
    end
  end

  describe '#apply_order_rules' do
    let!(:segment) { create(:segment) }
    let!(:users) { create_list(:user, 3, enterprise: segment.enterprise) }
    let!(:order_rule) { create(:segment_order_rule, segment_id: segment.id, operator: 1) }

    it 'returns users by order rules' do
      expect(segment.apply_order_rules(users)).to eq(users)
    end
  end

  describe '#general_rules_followed_by' do
    context 'when only_active' do
      it 'returns true' do
        user = create(:user, active: true)
        segment = create(:segment, active_users_filter: 'only_active')

        expect(segment.general_rules_followed_by?(user)).to be(true)
      end

      it 'returns false' do
        user = create(:user, active: true)
        segment = create(:segment, active_users_filter: 'only_active')

        expect(segment.general_rules_followed_by?(user)).to be(true)
      end
    end
    context 'when only_inactive' do
      it 'returns false' do
        user = create(:user, active: true)
        segment = create(:segment, active_users_filter: 'only_inactive')

        expect(segment.general_rules_followed_by?(user)).to be(false)
      end

      it 'returns true' do
        user = create(:user, active: false)
        segment = create(:segment, active_users_filter: 'only_inactive')

        expect(segment.general_rules_followed_by?(user)).to be(true)
      end
    end
  end

  describe '#update_all_members' do
    it 'calls CacheSegmentMembersJob' do
      expect(CacheSegmentMembersJob).to receive(:perform_later).at_least(:once)
      create(:segment)

      Segment.update_all_members
    end
  end
end
