require 'rails_helper'

RSpec.describe BudgetItemPolicy, type: :policy do
  let(:enterprise) { create(:enterprise) }
  let(:group) { create(:group, enterprise: enterprise) }
  let(:annual_budget) { create(:annual_budget, group: group) }
  let(:budget) { create(:budget, annual_budget: annual_budget) }
  let(:budget_item) { create(:budget_item, budget: budget) }
  let(:no_access) { create(:user) }
  let!(:user) { no_access }
  let!(:other_user) { no_access }

  subject { described_class.new(user.reload, [group, budget_item]) }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.groups_manage = false
    no_access.policy_group.initiatives_create = false
    no_access.policy_group.groups_budgets_manage = false
    no_access.policy_group.groups_budgets_request = false
    no_access.policy_group.save!
  }

  describe 'for users with access' do
    context 'when manage_all is false' do
      context 'index?' do
        context 'when visibility is not set' do
          context 'when ONLY initiatives_create is true' do
            before { user.policy_group.update initiatives_create: true }

            it 'returns true' do
              expect(subject.index?).to eq true
            end
          end

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

          context 'when only one permission is false' do
            before { user.policy_group.update initiatives_create: true
                     user.policy_group.update groups_budgets_manage: true
                     user.policy_group.update groups_budgets_request: true
            }
            context 'when ONLY initiatives_create is false' do
              before { user.policy_group.update initiatives_create: false }

              it 'returns false' do
                expect(subject.index?).to eq true
              end
            end

            context 'when ONLY groups_budgets_manage is false' do
              before { user.policy_group.update groups_budgets_manage: false }

              it 'returns false' do
                expect(subject.index?).to eq true
              end
            end

            context 'when ONLY groups_budgets_request is false' do
              before { user.policy_group.update groups_budgets_request: false }

              it 'returns false' do
                expect(subject.index?).to eq true
              end
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

      context 'close_budget?' do
        context 'when current user IS same as creator' do
          before do
            budget.requester = user
          end
          it 'returns true for #close_budget?' do
            expect(subject.close_budget?).to eq true
          end
        end
      end
    end

    context 'when manage_all is true' do
      before { user.policy_group.update manage_all: true }

      context 'when groups_budgets_manage, groups_manage and initiatives_create are false' do
        before { user.policy_group.update groups_budgets_manage: false, groups_manage: false, initiatives_create: false }
        it { is_expected.to permit_actions([:create, :destroy]) }

        it 'returns true for #index?' do
          expect(subject.index?).to eq true
        end

        it 'returns true for #manage?' do
          expect(subject.manage?).to eq true
        end

        it 'returns true for #create?' do
          expect(subject.create?).to eq true
        end
      end
    end
  end

  describe 'for users without access' do
    describe 'when manage_all is false' do
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

        context 'user has have group leader permissions but groups_budgets_manage is false: is_a_leader' do
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

        context 'user is not an accepted member and groups_budgets_manage is false: is_an_accepted_member' do
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

        context 'user has group leader permissions and groups_budgets_manage is false: is_a_leader' do
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

      context 'close_budget?' do
        context 'when current user IS not same as creator' do
          it 'returns false for #close_budget?' do
            expect(subject.close_budget?).to eq false
          end
        end
      end
    end
  end
end
