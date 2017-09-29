require 'rails_helper'

RSpec.describe GroupPolicy, :type => :policy do
    
    let(:policy_group){ create(:policy_group, :global_settings_manage => true)}
    let(:enterprise) {create(:enterprise, :policy_groups => [policy_group])}
    let(:user){ create(:user, :enterprise => enterprise) }
    let(:policy_group_2){ create(:policy_group, :groups_index => false, :groups_create => false, :groups_manage => false, :groups_budgets_index => false, :groups_budgets_request => false, :budget_approval => false)}
    let(:no_access) { create(:user, :policy_group => policy_group_2) }
    let(:group){ create(:group, :owner => user)}

    subject { described_class }
    
    permissions :index?, :plan_overview?, :metrics?, :create? , :update?, :view_members?,
                :manage_members?, :erg_leader_permissions?, :budgets?, :view_budget?, :request_budget?,
                :submit_budget?, :approve_budget? do
                  
        it "allows access" do
            expect(subject).to permit(user, group)
        end

        it "doesn't allow access" do
            expect(subject).to_not permit(no_access, group)
        end
    end
end
