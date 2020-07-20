require 'rails_helper'

RSpec.describe GroupUpdatePolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let(:group_update) { create(:group_update) }
  let(:no_access) { create(:user) }
  let!(:user) { no_access }

  subject { described_class.new(user.reload, [group, group_update]) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.groups_manage = false
    no_access.policy_group.groups_insights_manage = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'index?' do
        context 'when visibility is not set' do
          context 'when ONLY groups_insights_manage is true' do
            before { user.policy_group.update groups_insights_manage: true }

            it 'returns true' do
              expect(subject.index?).to eq true
            end
          end

          context 'when ONLY groups_insights_manage is true' do
            before { user.policy_group.update groups_insights_manage: true }

            it 'returns true' do
              expect(subject.index?).to eq true
            end
          end

          context 'when ONLY groups_insights_manage is true' do
            before { user.policy_group.update groups_insights_manage: true }

            it 'returns true' do
              expect(subject.index?).to eq true
            end
          end
        end
      end

      context 'manage?' do
        context 'user has groups_manage permission : is_admin_manager' do
          before do
            user.policy_group.update groups_manage: true
            user.policy_group.update groups_insights_manage: true
          end

          it 'returns true' do
            expect(subject.manage?).to eq true
          end
        end

        context 'user has group leader permissions : is_a_leader' do
          before do
            user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
            user_role.policy_group_template.update groups_insights_manage: true
            create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                  user_role_id: user_role.id)
          end

          it 'returns true' do
            expect(subject.manage?).to eq true
          end
        end

        context 'user is an accepted member : is_an_accepted_member' do
          before do
            create(:user_group, user_id: user.id, group_id: group.id, accepted_member: true)
            user.policy_group.update groups_insights_manage: true
          end

          it 'returns true' do
            expect(subject.manage?).to eq true
          end
        end
      end

      context 'create?' do
        context 'user has groups_manage permission : is_admin_manager' do
          before do
            user.policy_group.update groups_manage: true
            user.policy_group.update groups_insights_manage: true
          end

          it 'returns true' do
            expect(subject.create?).to eq true
          end
        end

        context 'user has group leader permissions : is_a_leader' do
          before do
            user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
            user_role.policy_group_template.update groups_insights_manage: true
            create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                  user_role_id: user_role.id)
          end

          it 'returns true' do
            expect(subject.create?).to eq true
          end
        end

        context 'user is an accepted member : is_an_accepted_member' do
          before do
            create(:user_group, user_id: user.id, group_id: group.id, accepted_member: true)
            user.policy_group.update groups_insights_manage: true
          end

          it 'returns true' do
            expect(subject.create?).to eq true
          end
        end
      end
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      context 'when groups_manage and groups_insights_manage are false' do
        before { user.policy_group.update groups_manage: false, groups_insights_manage: false }
        it { is_expected.to permit_actions([:create, :destroy]) }

        it 'returns true for #index?' do
          expect(subject.index?).to eq true
        end
      end
    end
  end
  describe 'for users without access' do
    describe 'for users with no access' do
      it { is_expected.to forbid_actions([:create, :destroy]) }
    end

    context 'index?' do
      context 'when visibility is not set' do
        context 'when ONLY groups_insights_manage is false' do
          before { user.policy_group.update groups_insights_manage: false }

          it 'returns false' do
            expect(subject.index?).to eq false
          end
        end

        context 'when ONLY groups_insights_manage is false' do
          before { user.policy_group.update groups_insights_manage: false }

          it 'returns false' do
            expect(subject.index?).to eq false
          end
        end

        context 'when ONLY groups_insights_manage is false' do
          before { user.policy_group.update groups_insights_manage: false }

          it 'returns false' do
            expect(subject.index?).to eq false
          end
        end
      end
    end

    context 'manage?' do
      context 'user doesnt have groups_manage permission and groups_insights_manage is false: is_admin_manager' do
        before do
          user.policy_group.update groups_manage: false
          user.policy_group.update groups_insights_manage: false
        end

        it 'returns false' do
          expect(subject.manage?).to eq false
        end
      end

      context 'user has group leader permissions and groups_insights_manage is false: is_a_leader' do
        before do
          user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update groups_insights_manage: false
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it 'returns false' do
          expect(subject.manage?).to eq false
        end
      end

      context 'user is an accepted member and groups_insights_manage is false: is_an_accepted_member' do
        before do
          create(:user_group, user_id: user.id, group_id: group.id, accepted_member: false)
          user.policy_group.update groups_insights_manage: false
        end

        it 'returns false' do
          expect(subject.manage?).to eq false
        end
      end
    end

    context 'create?' do
      context 'user doesnt have groups_manage permission and groups_insights_manage is false: is_admin_manager' do
        before do
          user.policy_group.update groups_manage: false
          user.policy_group.update groups_insights_manage: false
        end

        it 'returns false' do
          expect(subject.create?).to eq false
        end
      end

      context 'user has group leader permissions and groups_insights_manage is false: is_a_leader' do
        before do
          user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update groups_insights_manage: false
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it 'returns false' do
          expect(subject.create?).to eq false
        end
      end

      context 'user is not  an accepted member and groups_insights_manage is false : is_an_accepted_member' do
        before do
          create(:user_group, user_id: user.id, group_id: group.id, accepted_member: false)
          user.policy_group.update groups_insights_manage: false
        end

        it 'returns false' do
          expect(subject.create?).to eq false
        end
      end
    end
  end
end
