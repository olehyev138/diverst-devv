require 'rails_helper'

RSpec.describe GroupPolicy, :type => :policy do
    
    let(:policy_group){ create(:policy_group, :global_settings_manage => true, :groups_manage => false)}
    let(:enterprise) {create(:enterprise, :policy_groups => [policy_group])}
    let(:user){ create(:user, :enterprise => enterprise, :policy_group => policy_group) }
    let(:policy_group_2){ create(:policy_group, :groups_index => false, :groups_create => false, :groups_manage => false, :groups_budgets_index => false, :groups_budgets_request => false, :budget_approval => false)}
    let(:no_access) { create(:user, :policy_group => policy_group_2) }
    let(:group){ create(:group, :owner => user)}
    let(:group_2){ create(:group)}
    let(:group_leader){ create(:group_leader, :user => user, :group => group, :position => "Supreme Leader")}

    subject { described_class }
    
    context "when regular user" do
    
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
    
    context "when group_2 has no parent" do
    
        permissions :erg_leader_permissions? do
                      
            it "allows access for first group" do
                expect(subject).to permit(user, group)
            end
    
            it "doesn't allow access" do
                expect(subject).to_not permit(user, group_2)
            end
        end
    end
    
    context "when group_2 has parent" do
    
        permissions :erg_leader_permissions? do
                      
            it "allows access for first group" do
                expect(subject).to permit(user, group)
            end
    
            it "allows access for child group" do
                group.children << group_2
                expect(subject).to permit(user, group_2)
            end
        end
    end
end
