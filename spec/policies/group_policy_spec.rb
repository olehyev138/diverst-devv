require 'rails_helper'

RSpec.describe GroupPolicy, :type => :policy do
    
    let(:user){ create(:user) }
    let(:no_access) { create(:user) }
    let(:group){ create(:group, :owner => user, :enterprise_id => user.enterprise_id)}
    let(:group_2){ create(:group, :enterprise_id => user.enterprise_id)}
    let(:group_leader){ create(:group_leader, :user => user, :group => group, :position => "Supreme Leader")}
    let(:policy_scope) { GroupPolicy::Scope.new(user, Group).resolve }
    
    subject { described_class }
    
    before {
        no_access.policy_group.manage_all = false
        no_access.policy_group.groups_index = false
        no_access.policy_group.groups_create = false
        no_access.policy_group.groups_manage = false
        no_access.policy_group.groups_budgets_index = false
        no_access.policy_group.groups_members_index = false
        no_access.policy_group.groups_budgets_request = false
        no_access.policy_group.budget_approval = false
        no_access.policy_group.groups_manage = false
        no_access.policy_group.save!
    }
    
    permissions ".scope" do
        it "shows only groups belonging to enterprise" do
            expect(policy_scope).to eq [group]
        end
    end
    
    context "when regular user" do
    
        permissions :index?, :create? , :update?, :destroy? do
                      
            it "allows access" do
                expect(subject).to permit(user, group)
            end
    
            it "doesn't allow access" do
                expect(subject).to_not permit(no_access, group)
            end
        end
    end
end
