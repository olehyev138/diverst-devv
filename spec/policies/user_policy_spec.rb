require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:user) { create(:user, enterprise: enterprise) }
  let(:other_user) { create(:user, enterprise: enterprise) }
  let(:policy_scope) { UserPolicy::Scope.new(user, User).resolve }

  subject { UserPolicy.new(user.reload, other_user) }

  before {
    user.policy_group.manage_all = false
    user.policy_group.users_manage = false
    user.policy_group.users_index = false
    user.policy_group.save!
  }

  permissions '.scope' do
    before { user.policy_group.update users_index: true }

    it 'shows only users belonging to enterprise' do
      expect(policy_scope).to eq [user]
    end
  end

  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'when users_index is true but users_manage is false' do
        before { user.policy_group.update(users_index: true) }

        it { is_expected.to permit_actions([:index, :show]) }
      end

      context 'when users_index is false but users_manage is true' do
        before { user.policy_group.update(users_manage: true) }

        it { is_expected.to permit_actions([:index, :create, :show, :update, :destroy, :resend_invitation]) }
      end

      context 'when users_index, users_manage, manage_all are false but record IS the same as current user' do
        let(:other_user) { user }

        it { is_expected.to permit_action(:update) }
        it { is_expected.to forbid_action(:destroy) }
      end

      context 'when users_index, users_manage, manage_all are false but record IS NOT the same as curret user' do
        let(:other_user) { create(:user) }

        it { is_expected.to forbid_actions([:index, :show, :create, :update, :destroy, :resend_invitation ]) }
      end
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      context 'when record IS current user' do
        let(:other_user) { user }
        it { is_expected.to permit_actions([:index, :show, :create, :update, :resend_invitation]) }
      end

      context 'when record IS NOT current user' do
        it { is_expected.to permit_actions([:index, :show, :create, :update, :destroy, :resend_invitation]) }
      end
    end
  end

  describe 'for users with no access' do
    before { user.policy_group = create(:policy_group, :no_permissions) }

    it { is_expected.to forbid_actions([:index, :new, :create, :update, :destroy, :resend_invitation]) }
  end

  describe 'custom policies' do
    describe '#access_hidden_info?' do
      context 'when current user IS record' do
        let(:other_user) { user }

        it 'returns true' do
          expect(subject.access_hidden_info?).to eq true
        end
      end

      context 'when current user IS NOT record' do
        let(:other_user) { create(:user) }

        it 'returns false' do
          expect(subject.access_hidden_info?).to eq false
        end
      end

      context 'when manage_all is true' do
        before { user.policy_group.update manage_all: true }

        it 'returns true' do
          expect(subject.access_hidden_info?).to eq true
        end
      end

      context 'users_manage is true' do
        before { user.policy_group.update users_manage: true }

        it 'returns true' do
          expect(subject.access_hidden_info?).to eq true
        end
      end
    end

    describe '#join_or_leave_groups?' do
      context 'when current user IS record' do
        let(:other_user) { user }

        it 'returns true' do
          expect(subject.join_or_leave_groups?).to eq true
        end
      end

      context 'when current user IS NOT record' do
        let(:other_user) { create(:user) }

        it 'returns false' do
          expect(subject.join_or_leave_groups?).to eq true
        end
      end

      context 'when current user IS NOT record and has update permissions for GroupMemberPolicy' do
        let(:other_user) { create(:user) }
        before { user.policy_group.update groups_members_manage: false }

        it 'returns false' do
          expect(subject.join_or_leave_groups?).to eq false
        end
      end
    end

    describe '#user_not_current_user?' do
      context 'when current user IS NOT record' do
        let(:other_user) { create(:user) }

        it 'returns true' do
          expect(subject.user_not_current_user?).to eq true
        end
      end

      context 'when current user IS record' do
        let(:other_user) { user }

        it 'returns false' do
          expect(subject.user_not_current_user?).to eq false
        end
      end
    end

    describe '#users_points_ranking?' do
      context 'when manage_all is true' do
        before { user.policy_group.update manage_all: true }

        it 'returns true' do
          expect(subject.users_points_ranking?).to eq true
        end
      end

      context 'when users_manage is true' do
        before { user.policy_group.update users_manage: true }

        it 'returns true' do
          expect(subject.users_points_ranking?).to eq true
        end
      end
    end

    describe '#users_points_csv?' do
      context 'when manage_all is true' do
        before { user.policy_group.update manage_all: true }

        it 'returns true' do
          expect(subject.users_points_csv?).to eq true
        end
      end

      context 'when users_manage is true' do
        before { user.policy_group.update users_manage: true }

        it 'returns true' do
          expect(subject.users_points_csv?).to eq true
        end
      end
    end

    describe '#users_pending_rewards?' do
      context 'when manage_all is true' do
        before { user.policy_group.update manage_all: true }

        it 'returns true' do
          expect(subject.users_pending_rewards?).to eq true
        end
      end

      context 'when users_manage is true' do
        before { user.policy_group.update users_manage: true }

        it 'returns true' do
          expect(subject.users_pending_rewards?).to eq true
        end
      end
    end
  end
end
