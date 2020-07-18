require 'rails_helper'

RSpec.describe GroupMessagePolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let(:user) { no_access }
  let!(:group_message) { create(:group_message, group: group, owner: user) }

  subject { GroupMessagePolicy.new(user.reload, [group, group_message]) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.group_posts_index = false
    no_access.policy_group.group_messages_create = false
    no_access.policy_group.manage_posts = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'index?' do
        context 'when group.members_visibility is set to public' do
          before { group.members_visibility = 'public' }

          context 'when ONLY group_posts_index is true' do
            before { user.policy_group.update group_posts_index: true }

            it 'returns true' do
              expect(subject.index?).to eq true
            end
          end

          context 'when ONLY manage_posts is true' do
            before { user.policy_group.update manage_posts: true }

            it 'returns true' do
              expect(subject.index?).to eq true
            end
          end

          context 'when ONLY group_messages_create is true' do
            before { user.policy_group.update group_messages_create: true }

            it 'returns true' do
              expect(subject.index?).to eq true
            end
          end

          context 'user has basic leader permissions and groups_members_manage is true' do
            before do
              user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
              user_role.policy_group_template.update manage_posts: true
              create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                    user_role_id: user_role.id)
            end

            it 'returns true' do
              expect(subject.index?).to eq true
            end
          end
        end

        context 'when group.members_visibility is set to group' do
          before { group.members_visibility = 'group' }

          context 'when groups_manage and manage_posts are true' do
            before { user.policy_group.update groups_manage: true, manage_posts: true }

            it 'returns true' do
              expect(subject.index?).to eq true
            end
          end

          context 'user has group leader permissions : is_a_leader' do
            before do
              user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
              user_role.policy_group_template.update manage_posts: true
              create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                    user_role_id: user_role.id)
            end

            it 'returns true' do
              expect(subject.index?).to eq true
            end
          end

          context 'user is member and manage_posts is true : is_a_member' do
            before do
              create(:user_group, user_id: user.id, group_id: group.id)
              user.policy_group.update manage_posts: true
            end

            it 'returns true' do
              expect(subject.index?).to eq true
            end
          end

          context 'user has groups_manage permission : is_admin_manager' do
            before do
              user.policy_group.update groups_manage: true
              user.policy_group.update manage_posts: true
            end

            it 'returns true' do
              expect(subject.index?).to eq true
            end
          end
        end

        context 'when group.members_visibility is set to leader' do
          before { group.members_visibility = 'leaders_only' }
          context 'user has group leader permissions : is_a_leader' do
            before do
              user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
              user_role.policy_group_template.update manage_posts: true
              create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                    user_role_id: user_role.id)
            end

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
            user.policy_group.update manage_posts: true
          end

          it 'returns true' do
            expect(subject.manage?).to eq true
          end
        end

        context 'user has group leader permissions : is_a_leader' do
          before do
            user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
            user_role.policy_group_template.update manage_posts: true
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
            user.policy_group.update manage_posts: true
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
            user.policy_group.update manage_posts: true
          end

          it 'returns true' do
            expect(subject.create?).to eq true
          end
        end

        context 'user has group leader permissions : is_a_leader' do
          before do
            user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
            user_role.policy_group_template.update manage_posts: true
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
            user.policy_group.update manage_posts: true
          end

          it 'returns true' do
            expect(subject.create?).to eq true
          end
        end
      end

      context 'group.latest_news_visibility is nil' do
        before { group.latest_news_visibility = '' }

        context 'when owner IS NOT current user' do
          before { group_message.owner = create(:user) }

          context 'when ONLY manage_posts and groups_manage are true' do
            before { user.policy_group.update groups_manage: true, manage_posts: true }
            it { is_expected.to permit_actions([:index, :edit, :update, :destroy]) }
          end

          context 'when ONLY group_messages_create and groups_manage are true' do
            before { user.policy_group.update groups_manage: true, group_messages_create: true }
            it { is_expected.to permit_action(:index) }
          end

          context 'when ONLY group_posts_index and groups_manage are true' do
            before { user.policy_group.update groups_manage: true, group_posts_index: true }
            it { is_expected.to permit_action(:index) }
          end

          context 'user has group leader permission for manage_posts' do
            before do
              user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
              user_role.policy_group_template.update manage_posts: true
              create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                    user_role_id: user_role.id)
            end

            it { is_expected.to permit_actions([:index, :edit, :update, :destroy]) }
          end
        end
      end
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      context 'when groups_manage, manage_posts, manage_posts, social_links_create, group_posts_index are false' do
        it { is_expected.to permit_actions([:index, :edit, :update, :destroy]) }
      end
    end
  end

  describe 'for users with no access' do
    before { group_message.owner = create(:user) }
    it { is_expected.to forbid_actions([:index, :edit, :update, :destroy]) }

    context 'index?' do
      context 'when group.members_visibility is set to public' do
        before { group.members_visibility = 'public' }

        context 'when ONLY group_posts_index is false' do
          before { user.policy_group.update group_posts_index: false }

          it 'returns false' do
            expect(subject.index?).to eq false
          end
        end

        context 'when ONLY manage_posts is false' do
          before { user.policy_group.update manage_posts: false }

          it 'returns false' do
            expect(subject.index?).to eq false
          end
        end

        context 'when ONLY group_messages_create is false' do
          before { user.policy_group.update group_messages_create: false }

          it 'returns false' do
            expect(subject.index?).to eq false
          end
        end

        context 'user has basic leader permissions and groups_members_manage is false' do
          before do
            user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
            user_role.policy_group_template.update manage_posts: false
            create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                  user_role_id: user_role.id)
          end

          it 'returns false' do
            expect(subject.index?).to eq false
          end
        end
      end

      context 'when group.members_visibility is set to group' do
        before { group.members_visibility = 'group' }

        context 'when groups_manage and manage_posts are false' do
          before { user.policy_group.update groups_manage: false, manage_posts: false }

          it 'returns false' do
            expect(subject.index?).to eq false
          end
        end

        context 'user has group leader permissions and manage_posts is false: is_a_leader' do
          before do
            user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
            user_role.policy_group_template.update manage_posts: false
            create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                  user_role_id: user_role.id)
          end

          it 'returns false' do
            expect(subject.index?).to eq false
          end
        end

        context 'user is member and manage_posts is false and manage_posts is false: is_a_member' do
          before do
            create(:user_group, user_id: user.id, group_id: group.id)
            user.policy_group.update manage_posts: false
          end

          it 'returns false' do
            expect(subject.index?).to eq false
          end
        end

        context 'user has groups_manage permission and manage_posts is false: is_admin_manager' do
          before do
            user.policy_group.update groups_manage: false
            user.policy_group.update manage_posts: false
          end

          it 'returns false' do
            expect(subject.index?).to eq false
          end
        end
      end

      context 'when group.members_visibility is set to leader' do
        before { group.members_visibility = 'leaders_only' }
        context 'user has group leader permissions  and manage_posts is false: is_a_leader' do
          before do
            user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
            user_role.policy_group_template.update manage_posts: false
            create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                  user_role_id: user_role.id)
          end

          it 'returns false' do
            expect(subject.index?).to eq false
          end
        end
      end
    end

    context 'manage?' do
      context 'user has groups_manage permission and manage_posts is false: is_admin_manager' do
        before do
          user.policy_group.update groups_manage: false
          user.policy_group.update manage_posts: false
        end

        it 'returns false' do
          expect(subject.manage?).to eq false
        end
      end

      context 'user has group leader permissions and manage_posts is false: is_a_leader' do
        before do
          user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update manage_posts: false
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it 'returns false' do
          expect(subject.manage?).to eq false
        end
      end

      context 'user is an accepted member and manage_posts is false: is_an_accepted_member' do
        before do
          create(:user_group, user_id: user.id, group_id: group.id, accepted_member: false)
          user.policy_group.update manage_posts: false
        end

        it 'returns false' do
          expect(subject.manage?).to eq false
        end
      end
    end

    context 'create?' do
      context 'user has groups_manage permission and manage_posts is false: is_admin_manager' do
        before do
          user.policy_group.update groups_manage: false
          user.policy_group.update manage_posts: false
        end

        it 'returns false' do
          expect(subject.create?).to eq false
        end
      end

      context 'user has group leader permissions and manage_posts is false: is_a_leader' do
        before do
          user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update manage_posts: false
          create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                user_role_id: user_role.id)
        end

        it 'returns false' do
          expect(subject.create?).to eq false
        end
      end

      context 'user is not an accepted member and manage_posts is false: is_an_accepted_member' do
        before do
          create(:user_group, user_id: user.id, group_id: group.id, accepted_member: false)
          user.policy_group.update manage_posts: false
        end

        it 'returns false' do
          expect(subject.create?).to eq false
        end
      end
    end

    context 'group.latest_news_visibility is nil' do
      before { group.latest_news_visibility = '' }

      context 'when owner IS NOT current user' do
        before { group_message.owner = create(:user) }

        context 'when ONLY manage_posts and groups_manage are false' do
          before { user.policy_group.update groups_manage: false, manage_posts: false }
          it { is_expected.to forbid_actions([:index, :edit, :update, :destroy]) }
        end

        context 'when ONLY group_messages_create and groups_manage are false' do
          before { user.policy_group.update groups_manage: false, group_messages_create: false }
          it { is_expected.to forbid_action(:index) }
        end

        context 'when ONLY group_posts_index and groups_manage are false' do
          before { user.policy_group.update groups_manage: false, group_posts_index: false }
          it { is_expected.to forbid_action(:index) }
        end

        context 'user has group leader permission for manage_posts' do
          before do
            user_role = create(:user_role, enterprise: enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
            user_role.policy_group_template.update manage_posts: false
            create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                  user_role_id: user_role.id)
          end

          it { is_expected.to forbid_actions([:index, :edit, :update, :destroy]) }
        end
      end
    end
  end
end
