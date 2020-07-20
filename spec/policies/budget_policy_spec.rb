require 'rails_helper'

RSpec.describe BudgetPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let(:annual_budget) { create(:annual_budget, group: group) }
  let(:budget) { create(:budget, annual_budget: annual_budget) }
  let(:no_access) { create(:user) }
  let!(:user) { no_access }

  subject { described_class.new(user.reload, [group, budget]) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.groups_manage = false
    no_access.policy_group.groups_budgets_index = false
    no_access.policy_group.groups_budgets_request = false
    no_access.policy_group.groups_budgets_manage = false
    no_access.policy_group.budget_approval = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do
    context 'index?' do
      context 'when visibility is not set' do
        context 'when ONLY groups_budgets_manage is true' do
          before { user.policy_group.update groups_budgets_manage: true }

          it 'returns true' do
            expect(subject.index?).to eq true
          end
        end

        context 'when ONLY groups_budgets_request is true' do
          before { user.policy_group.update groups_budgets_request: true }

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
          user.policy_group.update groups_budgets_manage: true
        end

        it 'returns true' do
          expect(subject.manage?).to eq true
        end
      end

      context 'user has group leader permissions : is_a_leader' do
        before do
          user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update groups_budgets_manage: true
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
          user.policy_group.update groups_budgets_manage: true
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
          user.policy_group.update groups_budgets_manage: true
        end

        it 'returns true' do
          expect(subject.create?).to eq true
        end
      end

      context 'user has group leader permissions : is_a_leader' do
        before do
          user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
          user_role.policy_group_template.update groups_budgets_manage: true
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
          user.policy_group.update groups_budgets_manage: true
        end

        it 'returns true' do
          expect(subject.create?).to eq true
        end
      end
    end

    context 'destroy?' do
      context 'when budget is approved' do
        before { budget.is_approved = true }

        context 'when admin?' do
          before { allow(subject).to receive(:manage_all?).and_return(true) }

          it { is_expected.to permit_action(:destroy) }
        end
      end
    end

    context 'manage_all_budgets?' do
      context 'when manage_all is true' do
        before { user.policy_group.update manage_all: true }

        it 'returns true' do
          expect(subject.manage_all_budgets?).to eq true
        end
      end

      context 'when groups_budgets_manage and groups_manage are true' do
        before { user.policy_group.update groups_budgets_manage: true, groups_manage: true }

        it 'returns true' do
          expect(subject.manage_all_budgets?).to eq true
        end
      end
    end

    context 'approve?/decline?' do
      context 'when manage_all is false' do
        context 'when groups_manage and groups_budgets_manage are true' do
          before { user.policy_group.update groups_manage: true, groups_budgets_manage: true }

          it { is_expected.to permit_actions([:approve, :decline]) }
        end

        context 'user has group leader permissions and groups_budgets_manage is true' do
          before do
            user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
            user_role.policy_group_template.update groups_budgets_manage: true
            create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                  user_role_id: user_role.id)
          end

          it { is_expected.to permit_actions([:approve, :decline]) }
        end

        context 'user is group member and groups_budgets_manage is true' do
          before do
            create(:user_group, user_id: user.id, group_id: group.id, accepted_member: true)
            user.policy_group.update groups_budgets_manage: true
          end

          it { is_expected.to permit_actions([:approve, :decline]) }
        end

        context 'user has basic group leader permissions and budget_approval is true' do
          before do
            user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
            user_role.policy_group_template.update budget_approval: true
            create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                  user_role_id: user_role.id)
          end

          it { is_expected.to permit_actions([:approve, :decline]) }
        end

        context 'when budget_approval is true' do
          before { user.policy_group.update budget_approval: true }

          it { is_expected.to permit_actions([:approve, :decline]) }
        end
      end

      context 'when manage_all is true' do
        before { user.policy_group.update manage_all: true }

        context 'when budget_approval, groups_budgets_manage, groups_budgets_request, groups_budgets_index and groups_manage are false' do
          before { user.policy_group.update budget_approval: false, groups_budgets_index: false, groups_budgets_manage: false,
                                            groups_budgets_request: false, groups_manage: false
          }

          it { is_expected.to permit_actions([:approve, :decline]) }
        end
      end
    end
  end

  describe 'for users with no access' do
    it { is_expected.to forbid_actions([:approve, :decline]) }

    context 'when not admin?' do
      before { allow(subject).to receive(:manage_all?).and_return(false) }

      it { is_expected.to forbid_action(:destroy) }
    end

    context 'when budget is not approved' do
      context 'when current user is not requester' do
        let(:annual_budget) { create(:annual_budget, group_id: group.id) }
        let(:budget1) { create(:budget, annual_budget_id: annual_budget.id, requester: create(:user)) }
        subject { described_class.new(user, [group, budget1]) }

        before { allow(subject).to receive(:manage_all?).and_return(false) }

        it { is_expected.to forbid_action(:destroy) }
      end
    end

    describe 'when manage_all is false' do
      context 'index?' do
        context 'when visibility is not set' do
          context 'when ONLY groups_budgets_index is false' do
            before { user.policy_group.update groups_budgets_index: false }

            it 'returns false' do
              expect(subject.index?).to eq false
            end
          end

          context 'when ONLY groups_budgets_manage is false' do
            before { user.policy_group.update groups_budgets_manage: false }

            it 'returns false' do
              expect(subject.index?).to eq false
            end
          end

          context 'when ONLY groups_budgets_request is false' do
            before { user.policy_group.update groups_budgets_request: false }

            it 'returns false' do
              expect(subject.index?).to eq false
            end
          end
        end
      end

      context 'manage?' do
        context 'user doesnt have groups_manage permission : is_admin_manager' do
          before do
            user.policy_group.update groups_manage: false
            user.policy_group.update groups_budgets_manage: false
          end

          it 'returns false' do
            expect(subject.manage?).to eq false
          end
        end

        context 'user doesnt have group leader permissions : is_a_leader' do
          before do
            user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
            user_role.policy_group_template.update groups_budgets_manage: false
            create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                  user_role_id: user_role.id)
          end

          it 'returns false' do
            expect(subject.manage?).to eq false
          end
        end

        context 'user is not an accepted member : is_an_accepted_member' do
          before do
            create(:user_group, user_id: user.id, group_id: group.id, accepted_member: false)
            user.policy_group.update groups_budgets_manage: false
          end

          it 'returns false' do
            expect(subject.manage?).to eq false
          end
        end
      end

      context 'create?' do
        context 'user doesnt have groups_manage permission : is_admin_manager' do
          before do
            user.policy_group.update groups_manage: false
            user.policy_group.update groups_budgets_manage: false
          end

          it 'returns false' do
            expect(subject.create?).to eq false
          end
        end

        context 'user has have group leader permissions and groups_budgets_manage is false : is_a_leader' do
          before do
            user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
            user_role.policy_group_template.update groups_budgets_manage: false
            create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                  user_role_id: user_role.id)
          end

          it 'returns false' do
            expect(subject.create?).to eq false
          end
        end

        context 'user is not an accepted member and groups_budgets_manage is false: is_an_accepted_member' do
          before do
            create(:user_group, user_id: user.id, group_id: group.id, accepted_member: false)
            user.policy_group.update groups_budgets_manage: false
          end

          it 'returns false' do
            expect(subject.create?).to eq false
          end
        end
      end

      context 'destroy?' do
        context 'when budget is not approved' do
          context 'when current user is requester' do
            let(:annual_budget) { create(:annual_budget, group_id: group.id) }
            let(:budget1) { create(:budget, annual_budget_id: annual_budget.id, requester: user) }
            subject { described_class.new(user, [group, budget1]) }

            before { allow(subject).to receive(:manage_all?).and_return(false) }

            it { is_expected.to permit_action(:destroy) }
          end
        end
      end

      context 'manage_all_budgets?' do
        context 'when manage_all is false' do
          before { user.policy_group.update manage_all: false }

          it 'returns false' do
            expect(subject.manage_all_budgets?).to eq false
          end
        end

        context 'when groups_budgets_manage and groups_manage are false' do
          before { user.policy_group.update groups_budgets_manage: false, groups_manage: false }

          it 'returns false' do
            expect(subject.manage_all_budgets?).to eq false
          end
        end
      end

      context 'approve?/decline?' do
        context 'when manage_all is false' do
          context 'when groups_manage and groups_budgets_manage are false' do
            before { user.policy_group.update groups_manage: false, groups_budgets_manage: false }

            it { is_expected.to forbid_actions([:approve, :decline]) }
          end

          context 'user has group leader permissions and groups_budgets_manage is false' do
            before do
              user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
              user_role.policy_group_template.update groups_budgets_manage: false
              create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                    user_role_id: user_role.id)
            end

            it { is_expected.to forbid_actions([:approve, :decline]) }
          end

          context 'user is group member and groups_budgets_manage is false' do
            before do
              create(:user_group, user_id: user.id, group_id: group.id, accepted_member: false)
              user.policy_group.update groups_budgets_manage: false
            end

            it { is_expected.to forbid_actions([:approve, :decline]) }
          end

          context 'user has basic group leader permissions and budget_approval is false' do
            before do
              user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
              user_role.policy_group_template.update budget_approval: false
              create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                    user_role_id: user_role.id)
            end

            it { is_expected.to forbid_actions([:approve, :decline]) }
          end

          context 'when budget_approval is false' do
            before { user.policy_group.update budget_approval: false }

            it { is_expected.to forbid_actions([:approve, :decline]) }
          end
        end

        context 'when manage_all is false' do
          before { user.policy_group.update manage_all: false }

          context 'when budget_approval, groups_budgets_manage, groups_budgets_request, groups_budgets_index and groups_manage are false' do
            before { user.policy_group.update budget_approval: false, groups_budgets_index: false, groups_budgets_manage: false,
                                              groups_budgets_request: false, groups_manage: false
            }

            it { is_expected.to forbid_actions([:approve, :decline]) }
          end
        end
      end

      context 'approve?/decline?' do
        context 'when manage_all is false' do
          context 'when groups_manage and groups_budgets_manage are false' do
            before { user.policy_group.update groups_manage: false, groups_budgets_manage: false }

            it { is_expected.to forbid_actions([:approve, :decline]) }
          end

          context 'user doesnt have group leader permissions and groups_budgets_manage is false' do
            before do
              user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
              user_role.policy_group_template.update groups_budgets_manage: false
              create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                    user_role_id: user_role.id)
            end

            it { is_expected.to forbid_actions([:approve, :decline]) }
          end

          context 'user is not a group member and groups_budgets_manage is false' do
            before do
              create(:user_group, user_id: user.id, group_id: group.id, accepted_member: false)
              user.policy_group.update groups_budgets_manage: false
            end

            it { is_expected.to forbid_actions([:approve, :decline]) }
          end

          context 'user doesnt have basic group leader permissions and budget_approval is false' do
            before do
              user_role = create(:user_role, enterprise: user.enterprise, role_type: 'group', role_name: 'Group Leader', priority: 3)
              user_role.policy_group_template.update budget_approval: false
              create(:group_leader, group_id: group.id, user_id: user.id, position_name: 'Group Leader',
                                    user_role_id: user_role.id)
            end

            it { is_expected.to forbid_actions([:approve, :decline]) }
          end

          context 'when budget_approval is false' do
            before { user.policy_group.update budget_approval: false }

            it { is_expected.to forbid_actions([:approve, :decline]) }
          end
        end

        context 'when manage_all is false' do
          before { user.policy_group.update manage_all: false }

          context 'when budget_approval, groups_budgets_manage, groups_budgets_request, groups_budgets_index and groups_manage are false' do
            before { user.policy_group.update budget_approval: false, groups_budgets_index: false, groups_budgets_manage: false,
                                              groups_budgets_request: false, groups_manage: false
            }

            it { is_expected.to forbid_actions([:approve, :decline]) }
          end
        end
      end
    end
  end
end