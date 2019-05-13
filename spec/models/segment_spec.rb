require 'rails_helper'

RSpec.describe Segment, type: :model do
  describe 'when validating' do
    let(:segment) { build_stubbed(:segment) }

    it { expect(segment).to have_one(:parent_segment).class_name('Segmentation').with_foreign_key(:child_id) }
    it { expect(segment).to have_one(:parent).class_name('Segment').through(:parent_segment).source(:parent) }

    it { expect(segment).to have_many(:children).class_name('Segmentation').with_foreign_key(:parent_id) }
    it { expect(segment).to have_many(:sub_segments).class_name('Segment').through(:children).source(:child).dependent(:destroy) }

    it { expect(segment).to belong_to(:enterprise) }
    it { expect(segment).to belong_to(:owner).class_name('User') }

    it { expect(segment).to have_many(:rules).class_name('SegmentRule') }
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
    it { expect(segment).to accept_nested_attributes_for(:rules).allow_destroy(true) }
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
  describe 'test callbacks' do
    let!(:segment) { create(:segment) }

    context 'before_destroy' do
      it 'callback runs before segment object is destroyed' do
        expect(segment).to receive(:remove_parent_segment)
        segment.destroy
      end
    end
  end

  describe 'associations' do
    it 'creates parent segment and children' do
      parent = create(:segment)

      3.times do
        child = create(:segment)
        parent.sub_segments << child
        parent.save
      end

      expect(parent.sub_segments.count).to eq(3)
      parent.sub_segments.each do |sub_segment|
        expect(sub_segment.parent.id).to eq(parent.id)
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
    context 'when nil' do
      it 'returns true' do
        user = create(:user, active: true)
        segment = create(:segment, active_users_filter: nil)

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

  describe '#remove_parent_segment' do
    it 'removes the parent segmentation' do
      parent = create(:segment)
      child = create(:segment)
      segmentation = create(:segmentation, child: child, parent: parent)

      # make sure parent segment exists
      expect(child.parent_segment.present?).to be(true)

      # delete the child
      child.destroy

      expect(parent.present?).to be(true)
      expect { segmentation.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
