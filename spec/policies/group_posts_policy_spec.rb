require 'rails_helper'

RSpec.describe GroupPostsPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let(:user) { no_access }
  let(:message) { create(:group_message, owner: user, group: group) }

  subject { described_class.new(user.reload, [group, message]) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.group_posts_index = false
    no_access.policy_group.manage_posts = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'view_latest_news?' do
        context 'when group.members_visibility is set to public' do
          before { group.members_visibility = 'public' }

          context 'when ONLY groups_posts_index is true' do
            before { user.policy_group.update group_posts_index: true }

            it 'returns true' do
              expect(subject.view_latest_news?).to eq true
            end
          end

          context 'when ONLY manage_posts is true' do
            before { user.policy_group.update manage_posts: true }

            it 'returns true' do
              expect(subject.view_latest_news?).to eq true
            end
          end

          context 'when ONLY manage_posts is true' do
            before { user.policy_group.update manage_posts: true }

            it 'returns true' do
              expect(subject.view_latest_news?).to eq true
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
              expect(subject.view_latest_news?).to eq true
            end
          end
        end

        context 'when group.members_visibility is set to group' do
          before { group.members_visibility = 'group' }

          context 'when groups_manage and manage_posts are true' do
            before { user.policy_group.update groups_manage: true, manage_posts: true }

            it 'returns true' do
              expect(subject.view_latest_news?).to eq true
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
              expect(subject.view_latest_news?).to eq true
            end
          end

          context 'user is member and manage_posts is true : is_a_member' do
            before do
              create(:user_group, user_id: user.id, group_id: group.id)
              user.policy_group.update manage_posts: true
            end

            it 'returns true' do
              expect(subject.view_latest_news?).to eq true
            end
          end

          context 'user has groups_manage permission : is_admin_manager' do
            before do
              user.policy_group.update groups_manage: true
              user.policy_group.update manage_posts: true
            end

            it 'returns true' do
              expect(subject.view_latest_news?).to eq true
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
              expect(subject.view_latest_news?).to eq true
            end
          end
        end

        context 'when group.latest_news_visibility is set to nil' do
          before { group.latest_news_visibility = nil }

          it 'returns false' do
            expect(subject.view_latest_news?).to eq false
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
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      context 'when group.latest_news_visibility is public' do
        before { group.latest_news_visibility = 'public' }

        context 'when group_posts_index and manage_posts are false' do
          it 'returns false' do
            expect(subject.view_latest_news?).to eq true
          end
        end

        context 'when group.latest_news_visibility is group' do
          before { group.latest_news_visibility = 'group' }

          it 'returns true' do
            expect(subject.view_latest_news?).to eq true
          end
        end
      end
    end
  end

  describe 'for users with no access' do
    let!(:user) { no_access }

    it 'returns false' do
      expect(subject.view_latest_news?).to eq false
    end
  end
end
