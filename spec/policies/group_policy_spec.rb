require 'rails_helper'

RSpec.describe GroupPolicy, :type => :policy do
    
    let(:user){ create(:user) }
    let(:no_access) { create(:user) }
    let(:group){ create(:group, :owner => user)}
    let(:group_2){ create(:group)}
    let(:group_leader){ create(:group_leader, :user => user, :group => group, :position => "Supreme Leader")}

    subject { described_class }
    
    before {
        no_access.policy_group.groups_index = false
        no_access.policy_group.groups_create = false
        no_access.policy_group.groups_manage = false
        no_access.policy_group.groups_budgets_index = false
        no_access.policy_group.annual_budget_manage = false
        no_access.policy_group.groups_members_index = false
        no_access.policy_group.groups_budgets_request = false
        no_access.policy_group.budget_approval = false
        no_access.policy_group.groups_manage = false
        no_access.policy_group.save!
    }
    
    context "when regular user" do
    
        permissions :index?, :plan_overview?, :metrics?, :create? , :update?, 
                    :erg_leader_permissions?, :budgets?, :view_budget?, :request_budget?,
                    :submit_budget?, :approve_budget?, :decline_budget?, :destroy? do
                      
            it "allows access" do
                expect(subject).to permit(user, group)
            end
    
            it "doesn't allow access" do
                expect(subject).to_not permit(no_access, group)
            end
        end
        
        permissions :view_members? do
            context "global" do
                it "allows access" do
                    group.members_visibility = "global"
                    group.save!
                    
                    expect(subject).to permit(user, group)
                end
            end
            
            context "group" do
                it "allows access" do
                    create(:user_group, :user => user, :group => group, :accepted_member => true)
                    group.members_visibility = "group"
                    group.save!
                    
                    expect(subject).to permit(user, group)
                end
            end
            
            context "managers_only" do
                it "allows access" do
                    group.members_visibility = "managers_only"
                    group.save!
                    
                    expect(subject).to permit(user, group)
                end
            end
        end
        
        permissions :view_messages? do
            context "global" do
                it "allows access" do
                    group.messages_visibility = "global"
                    group.save!
                    
                    expect(subject).to permit(user, group)
                end
            end
            
            context "group" do
                it "allows access" do
                    create(:user_group, :user => user, :group => group, :accepted_member => true)
                    group.messages_visibility = "group"
                    group.save!
                    
                    expect(subject).to permit(user, group)
                end
            end
            
            context "managers_only" do
                it "allows access" do
                    group.messages_visibility = "managers_only"
                    group.save!
                    
                    expect(subject).to permit(user, group)
                end
            end
        end
    end
    
    context "when group_2 has no parent" do
    
        permissions :erg_leader_permissions? do
                      
            it "allows access for first group" do
                expect(subject).to permit(user, group)
            end
    
            it "doesn't allow access" do
                user.policy_group.groups_manage = false
                user.policy_group.save!
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
    
    context "when user is erg_leader" do
    
        permissions :close_budgets? do
                      
            it "does not allow access" do
                user.policy_group.groups_index = false
                user.policy_group.annual_budget_manage = false
                user.policy_group.save!
                
                expect(subject).to_not permit(user, group)
            end
        end
    end
end
