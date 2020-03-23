require 'rails_helper'

RSpec.describe GroupEventsPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let(:no_access) { create(:user, enterprise: enterprise) }
  let!(:user) { no_access }
  let(:upcoming_event) { create(:initiative, owner: no_access, owner_group: group,
                                             start: DateTime.now.tomorrow, end: DateTime.now >> 1)
  }
  let(:ongoing_event) { create(:initiative, owner: no_access, owner_group: group,
                                            start: DateTime.now.weeks_ago(1), end: DateTime.now >> 1)
  }
  let!(:event) { upcoming_event }

  subject { described_class.new(user.reload, [group, event]) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.initiatives_index = false
    no_access.policy_group.initiatives_create = false
    no_access.policy_group.initiatives_manage = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'when group.upcoming_events_visibility is public' do
        before { group.upcoming_events_visibility = 'public' }

        context 'when ONLY initiatives_manage is true' do
          before { user.policy_group.update initiatives_manage: true }

          it 'returns true' do
            expect(subject.view_upcoming_events?).to eq true
          end
        end

        context 'when ONLY initiatives_index is true' do
          before { user.policy_group.update initiatives_index: true }

          it 'returns true' do
            expect(subject.view_upcoming_events?).to eq true
          end
        end

        context 'when ONLY initiatives_create is true' do
          before { user.policy_group.update initiatives_create: true }

          it 'return true' do
            expect(subject.view_upcoming_events?).to eq true
          end
        end

        context 'user has basic leader permissions and initiatives_manage is true' do
          before do
            user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
            user_role.policy_group_template.update initiatives_manage: true
            create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                  user_role_id: user_role.id)
          end

          it 'return true' do
            expect(subject.view_upcoming_events?).to eq true
          end
        end

        context 'user has basic leader permissions and initiatives_create is true' do
          before do
            user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
            user_role.policy_group_template.update initiatives_create: true
            create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                  user_role_id: user_role.id)
          end

          it 'return true' do
            expect(subject.view_upcoming_events?).to eq true
          end
        end

        context 'user has basic leader permissions and initiatives_index is true' do
          before do
            user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
            user_role.policy_group_template.update initiatives_index: true
            create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                  user_role_id: user_role.id)
          end

          it 'return true' do
            expect(subject.view_upcoming_events?).to eq true
          end
        end
      end

      context 'when group.upcoming_events_visibility is group' do
        before { group.upcoming_events_visibility = 'group' }

        context 'when groups manage and initiatives_manage are true' do
          before { user.policy_group.update groups_manage: true, initiatives_manage: true }

          it 'return true' do
            expect(subject.view_upcoming_events?).to eq true
          end
        end

        context 'user has group leader permissions and  initiatives_manage is true' do
          before do
            user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
            user_role.policy_group_template.update initiatives_manage: true
            create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                  user_role_id: user_role.id)
          end

          it 'returns true' do
            expect(subject.view_upcoming_events?).to eq true
          end
        end

        context 'user is group member and initiatives_manage is true' do
          before do
            create(:user_group, user_id: user.id, group_id: group.id, accepted_member: true)
            user.policy_group.update initiatives_manage: true
          end

          it 'returns true' do
            expect(subject.view_upcoming_events?).to eq true
          end
        end
      end

      context 'when group.upcoming_events_visibility is set to leaders_only' do
        before { group.upcoming_events_visibility = 'leaders_only' }

        context 'when user is group manager, with initiatives_manage set to true' do
          before { user.policy_group.update groups_manage: true, initiatives_manage: true }

          it 'returns true' do
            expect(subject.view_upcoming_events?).to eq true
          end
        end

        context 'when user is group manager, with initiatives_create set to true' do
          before { user.policy_group.update groups_manage: true, initiatives_create: true }

          it 'returns true' do
            expect(subject.view_upcoming_events?).to eq true
          end
        end

        context 'when user is group manager, with initiatives_index set to true' do
          before { user.policy_group.update groups_manage: true, initiatives_index: true }

          it 'returns true' do
            expect(subject.view_upcoming_events?).to eq true
          end
        end
      end

      context 'when group.upcoming_events_visibility is set to nil' do
        before { group.upcoming_events_visibility = nil }

        it 'returns false' do
          expect(subject.view_upcoming_events?).to eq false
        end
      end
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      context 'when initiatives_manage, initiatives_index and initiatives_create are false' do
        before { user.policy_group.update initiatives_create: false, initiatives_index: false, initiatives_manage: false }

        it 'returns true' do
          expect(subject.view_upcoming_events?).to eq true
        end
      end
    end
  end

  describe 'for users with no access' do
    it 'returns false' do
      expect(subject.view_upcoming_events?).to eq false
    end
  end
end
