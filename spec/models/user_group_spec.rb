require 'rails_helper'

RSpec.describe UserGroup do
  it_behaves_like 'it Contains Field Data'

  describe 'when validating' do
    let(:user_group) { build_stubbed(:user_group) }

    it { expect(user_group).to belong_to(:user) }
    it { expect(user_group).to belong_to(:group) }
    it { expect(user_group).to validate_length_of(:data).is_at_most(65535) }

    it 'validates 1 user per group' do
      group_member = create(:user)
      group = create(:group)
      group_member_1 = create(:user_group, user: group_member, group: group)
      group_member_2 = build(:user_group, user: group_member, group: group)

      expect(group_member.valid?).to be(true)
      expect(group.valid?).to be(true)
      expect(group_member_1.valid?).to be(true)

      # ensure the user cannot be added as a member to the same group twice
      expect(group_member_2.valid?).to be(false)
      expect(group_member_2.errors.full_messages.first).to eq('User is already a member of this group')
    end
  end

  describe 'when scoping' do
    let(:user_group) { build_stubbed(:user_group) }

    context 'top_participants' do
      let(:first) { create(:user_group, total_weekly_points: 30) }
      let(:third) { create(:user_group, total_weekly_points: 10) }
      let(:second) { create(:user_group, total_weekly_points: 20) }

      it 'returns top_participants' do
        expect(UserGroup.top_participants(3)).to eq [first, second, third]
      end
    end

    context 'active' do
      let!(:user_group) { create(:user_group) }

      it 'returns active user' do
        expect(UserGroup.active).to eq([user_group])
      end
    end

    context 'inactive' do
      let!(:user_group) { create(:user_group, user: create(:user, active: false)) }

      it 'returns inactive user' do
        expect(UserGroup.inactive).to eq([user_group])
      end
    end

    context 'pending' do
      let!(:user_group) { create(:user_group, accepted_member: false, group: create(:group, pending_users: 'enabled')) }

      it 'returns pending user' do
        expect(UserGroup.pending).to eq([user_group])
      end
    end

    context 'with_answered_survey' do
      let!(:user_group) { create(:user_group, data: 'test') }

      it 'returns users with answered_survey' do
        expect(UserGroup.with_answered_survey).to eq([user_group])
      end
    end

    describe '#for_segment_ids' do
      let!(:user) { create(:user) }
      let!(:segment) { create(:segment) }
      let!(:user_segment) { create(:users_segment, user_id: user.id, segment_id: segment.id) }
      let!(:user_group) { create(:user_group, user: user) }

      it 'returns users with segment_ids' do
        expect(UserGroup.for_segment_ids([segment.id])).to eq([user_group])
      end
    end

    context 'joined_from' do
      let!(:user_group) { create_list(:user_group, 3) }

      it 'returns users joined_from' do
        expect(UserGroup.joined_from(Date.yesterday).count).to eq 3
      end
    end

    context 'joined_to' do
      let!(:user_group) { create_list(:user_group, 3) }

      it 'returns users joined_to' do
        expect(UserGroup.joined_to(Date.tomorrow).count).to eq 3
      end
    end

    context 'user_search' do
      let!(:user1) { create(:user, email: 'test1@gmail.com') }
      let!(:user2) { create(:user, first_name: 'testfirst') }
      let!(:user3) { create(:user, last_name: 'lasttest') }
      before do
        create(:user_group, user: user1)
        create(:user_group, user: user2)
        create(:user_group, user: user3)
      end

      it 'returns user search' do
        expect(UserGroup.user_search('test').count).to eq 3
      end
    end

    describe '.accepted_users' do
      let(:enterprise) { create :enterprise }
      let(:user1) { create :user, enterprise: enterprise }
      let(:user2) { create :user, enterprise: enterprise }

      let(:group) { create :group, enterprise: enterprise }

      let(:user_group1) { create :user_group, user: user1, group: group, accepted_member: true }
      let(:user_group2) { create :user_group, user: user2, group: group, accepted_member: false }

      context 'with pending users enabled' do
        before { group.update(pending_users: 'enabled') }

        it 'returns only accepted member' do
          expect(group.user_groups.accepted_users).to include user_group1
          expect(group.user_groups.accepted_users).to_not include user_group2
        end
      end

      context 'with pending users disabled' do
        before { group.update(pending_users: 'disabled') }

        it 'returns all members' do
          expect(group.user_groups.accepted_users).to include user_group1
          expect(group.user_groups.accepted_users).to include user_group2
        end
      end
    end
  end

  describe 'when describing callbacks', skip: true do
    let!(:user) { create(:user) }

    it 'should reindex user on elasticsearch after create' do
      user_group = build(:user_group, user:  user)
      TestAfterCommit.with_commits(true) do
        expect(IndexElasticsearchJob).to receive(:perform_later).with(
          model_name: 'User',
          operation: 'update',
          index: User.es_index_name(enterprise: user_group.user.enterprise),
          record_id: user_group.user.id
        )
        user_group.save
      end
    end

    it 'should reindex user on elasticsearch after destroy' do
      user_group = create(:user_group, user: user)
      TestAfterCommit.with_commits(true) do
        expect(IndexElasticsearchJob).to receive(:perform_later).with(
          model_name: 'User',
          operation: 'update',
          index: User.es_index_name(enterprise: user_group.user.enterprise),
          record_id: user_group.user.id
        )
        user_group.destroy
      end
    end
  end

  describe '#string_for_field' do
    let!(:group) { create(:group) }
    let!(:select_field) { create(:select_field, title: 'Gender', options_text: "Male\nFemale", field_definer: group, field_type: 'group_survey') }
    let!(:user_group) { group.reload ; create(:user_group, group: group) }

    it 'returns the string field' do
      user_group[select_field] = ['Female']
      expect(user_group.string_for_field(select_field)).to eq('Female')
    end
  end

  describe '#remove_leader_role' do
    context 'when user is a basic user and role is elevated to group leader' do
      it 'does not set the basic users role to group_leader' do
        enterprise = create(:enterprise)
        admin = create(:user, user_role: enterprise.user_roles.where(role_name: 'admin').first, enterprise: enterprise)
        enterprise = admin.enterprise
        basic_user = create(:user, enterprise: enterprise, user_role: enterprise.user_roles.where(role_name: 'user').first)
        group = create(:group, enterprise: enterprise)

        expect(basic_user.user_role.role_name).to eq('user')
        user_group = create(:user_group, user: basic_user, group: group)
        create(:group_leader, user_role: enterprise.user_roles.where(role_name: 'group_leader').first, user: basic_user, group: group)

        # expect the user role to not change
        expect(basic_user.user_role.role_name).to eq('user')

        # remove the group member and check the role
        user_group.destroy
        basic_user.reload

        expect(basic_user.user_role.role_name).to eq('user')
        expect(GroupLeader.where(user_id: basic_user.id).count).to eq(0)
      end
    end
  end

  describe '#update_mentor_fields' do
    it 'updates mentor fields to true' do
      user = create(:user)
      group = create(:group, default_mentor_group: true)
      create(:user_group, group: group, user: user)
      user.reload

      expect(user.mentor?).to be(true)
      expect(user.mentee?).to be(true)
    end

    it 'updates mentor fields to true and then back to false' do
      user = create(:user)
      group = create(:group, default_mentor_group: true)
      user_group = create(:user_group, group: group, user: user)
      user.reload

      expect(user.mentor?).to be(true)
      expect(user.mentee?).to be(true)

      user_group.destroy
      user.reload

      expect(user.mentor?).to be(false)
      expect(user.mentee?).to be(false)
    end
  end

  describe 'elasticsearch methods' do
    context '#as_indexed_json' do
      let!(:object) { create(:user_group) }

      it 'serializes the correct fields with the correct data' do
        hash = {
          'user_id' => object.user_id,
          'group_id' => object.group_id,
          'created_at' => object.created_at.beginning_of_hour,
          'group' => {
            'enterprise_id' => object.group.enterprise_id,
            'name' => object.group.name,
            'parent_id' => object.group.parent_id
          },
          'user' => {
            'created_at' => object.user.created_at.beginning_of_hour,
            'enterprise_id' => object.user.enterprise_id,
            'mentor' => object.user.mentor,
            'mentee' => object.user.mentee,
            'active' => object.user.active
          },
          'field_data' => object.field_data
        }
        expect(object.as_indexed_json).to eq(hash)
      end
    end
  end
end
