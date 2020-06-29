require 'rails_helper'

RSpec.describe UserGroupPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let(:member) { create(:user, enterprise: enterprise) }
  let(:user_group) { create(:user_group) }
  let(:user) { no_access }

  subject { described_class.new(user.reload, [group, user_group]) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.groups_manage = false
    no_access.policy_group.groups_members_index = false
    no_access.policy_group.groups_members_manage = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'when group.members_visibility is set to global' do
        before { group.members_visibility = 'global' }

        context 'when ONLY groups_members_manage is true' do
          before { user.policy_group.update groups_members_manage: true }

          it 'returns true' do
            expect(subject.view_members?).to eq true
          end
        end

        context 'when ONLY groups_members_index is true' do
          before { user.policy_group.update groups_members_index: true }

          it 'returns true' do
            expect(subject.view_members?).to eq true
          end
        end

        context 'user has basic leader permissions and groups_members_manage is true' do
          before do
            user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
            user_role.policy_group_template.update groups_members_manage: true
            create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                  user_role_id: user_role.id)
          end

          it 'returns true' do
            expect(subject.view_members?).to eq true
          end
        end

        context 'user has basic leader permissions and groups_members_index is true' do
          before do
            user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
            user_role.policy_group_template.update groups_members_index: true
            create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                  user_role_id: user_role.id)
          end

          it 'returns true' do
            expect(subject.view_members?).to eq true
          end
        end
      end

      context 'when group.members_visibility is set to group' do
        before { group.members_visibility = 'group' }

        context 'when groups_manage and groups_members_manage are true' do
          before { user.policy_group.update groups_manage: true, groups_members_manage: true }

          it 'returns true' do
            expect(subject.view_members?).to eq true
          end
        end

        context 'user has group leader permissions' do
          before do
            user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
            user_role.policy_group_template.update groups_members_manage: true
            create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                  user_role_id: user_role.id)
          end

          it 'returns true' do
            expect(subject.view_members?).to eq true
          end
        end

        context 'user is member and groups_members_manage is true' do
          before do
            create(:user_group, user_id: user.id, group_id: group.id)
            user.policy_group.update groups_members_manage: true
          end

          it 'returns true' do
            expect(subject.view_members?).to eq true
          end
        end
      end

      context 'when group.members_visibility is set to leader' do
        before { group.members_visibility = 'leader' }

        context 'when user is a manager' do
          context 'when groups_manage and groups_members_manage are true' do
            before { user.policy_group.update groups_manage: true, groups_members_manage: true }

            it 'returns true' do
              expect(subject.view_members?).to eq true
            end
          end

          context 'has group leader permissions' do
            before do
              user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
              user_role.policy_group_template.update groups_members_manage: true
              create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                    user_role_id: user_role.id)
            end

            it 'returns true' do
              expect(subject.view_members?).to eq true
            end
          end

          context 'when groups_manage and groups_members_index are true' do
            before { user.policy_group.update groups_manage: true, groups_members_index: true }

            it 'returns true' do
              expect(subject.view_members?).to eq true
            end
          end

          context 'has group leader permissions' do
            before do
              user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
              user_role.policy_group_template.update groups_members_index: true
              create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                    user_role_id: user_role.id)
            end

            it 'returns true' do
              expect(subject.view_members?).to eq true
            end
          end
        end
      end

      context 'when group.members_visibility is set to nil' do
        before { group.members_visibility = nil }

        it 'returns true' do
          expect(subject.view_members?).to eq false
        end
      end

      context 'when current user IS same as record' do
        let!(:member) { user }
        it { is_expected.to permit_actions([:create, :destroy]) }
      end

      context 'when groups_manage and groups_members_manage are true and current user IS NOT same as record' do
        let!(:member) { create(:user) }
        before { user.policy_group.update groups_manage: true, groups_members_manage: true }
        it { is_expected.to permit_actions([:create, :destroy]) }
      end
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      context 'when groups_members_manage, groups_manage and groups_members_index are false' do
        before { user.policy_group.update groups_members_manage: false, groups_manage: false, groups_members_index: false }
        it { is_expected.to permit_actions([:create, :destroy]) }

        it 'returns true for #view_members?' do
          group.members_visibility = 'global'
          expect(subject.view_members?).to eq true
        end
      end
    end
  end
end
