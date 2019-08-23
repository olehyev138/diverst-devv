require 'rails_helper'

RSpec.describe Segment, type: :model do
  describe 'when validating' do
    let(:segment) { build_stubbed(:segment) }

    it { expect(segment).to belong_to(:parent).class_name('Segment') }
    it { expect(segment).to have_many(:children).class_name('Segment') }

    it { expect(segment).to belong_to(:enterprise) }
    it { expect(segment).to belong_to(:owner).class_name('User') }

    # Rules
    it { expect(segment).to have_many(:field_rules).class_name('SegmentFieldRule') }
    it { expect(segment).to have_many(:order_rules).class_name('SegmentOrderRule') }
    it { expect(segment).to have_many(:group_rules).class_name('SegmentGroupScopeRule') }

    it { expect(segment).to have_many(:users_segments) }
    it { expect(segment).to have_many(:members).through(:users_segments).class_name('User').source(:user).dependent(:destroy) }
    it { expect(segment).to have_many(:polls_segments) }
    it { expect(segment).to have_many(:polls).through(:polls_segments) }
    it { expect(segment).to have_many(:group_messages_segments) }
    it { expect(segment).to have_many(:group_messages).through(:group_messages_segments) }
    it { expect(segment).to have_many(:invitation_segments_groups) }
    it { expect(segment).to have_many(:groups).through(:invitation_segments_groups).inverse_of(:invitation_segments) }
    it { expect(segment).to have_many(:initiative_segments) }
    it { expect(segment).to have_many(:initiatives).through(:initiative_segments) }

    it { expect(segment).to validate_presence_of(:name) }
    it { expect(segment).to validate_presence_of(:enterprise) }
    it { expect(segment).to validate_presence_of(:active_users_filter) }

    # Nested rule attributes
    it { expect(segment).to accept_nested_attributes_for(:field_rules).allow_destroy(true) }
    it { expect(segment).to accept_nested_attributes_for(:order_rules).allow_destroy(true) }
    it { expect(segment).to accept_nested_attributes_for(:group_rules).allow_destroy(true) }
  end

  describe 'test validation' do
    let!(:enterprise) { create(:enterprise) }
    let!(:segment) { create(:segment, name: 'Females', enterprise: enterprise) }
    it { expect(segment).to validate_uniqueness_of(:name).scoped_to(:enterprise_id) }

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
