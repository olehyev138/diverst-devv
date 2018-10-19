require 'rails_helper'

RSpec.describe UserPolicy, :type => :policy do
    
    let(:enterprise) {create(:enterprise)}
    let(:user){ create(:user, :enterprise => enterprise) }
    let(:enterprise_2) {create(:enterprise)}
    let(:no_access) { create(:user, :enterprise => enterprise_2) }
    let(:policy_scope) { UserPolicy::Scope.new(user, User).resolve }
    
    subject { described_class }

    permissions ".scope" do
        it "shows only users belonging to enterprise" do
            expect(policy_scope).to eq [user]
        end
    end
    
    describe "index?" do
        let!(:user) {create(:user)}
        
        permissions :index? do
            it "allows access when users_index is true" do
                user.policy_group.users_index = true
                user.policy_group.users_manage = false
                user.policy_group.save!
            
                expect(subject).to permit(user)
            end
            
            it "allows access when users_manage is true but users_index is false" do
                user.policy_group.users_index = false
                user.policy_group.users_manage = true
                user.policy_group.save!
            
                expect(subject).to permit(user)
            end
            
            it "doesn't allow access when users_index/manage is false" do
                user.policy_group.users_index = false
                user.policy_group.users_manage = false
                user.policy_group.save!
            
                expect(subject).to_not permit(user)
            end
        end
    end
    
    describe "create?" do
        let!(:user) {create(:user)}
        
        permissions :create? do
            it "doesn't allow access when users_manage is false" do
                user.policy_group.users_index = false
                user.policy_group.users_manage = false
                user.policy_group.save!
            
                expect(subject).to_not permit(user)
            end
            
            it "doesn't allow access when users_manage is false but users_index is true" do
                user.policy_group.users_index = true
                user.policy_group.users_manage = false
                user.policy_group.save!
            
                expect(subject).to_not permit(user)
            end
            
            it "allows access when users_manage is true but users_index is false" do
                user.policy_group.users_index = false
                user.policy_group.users_manage = true
                user.policy_group.save!
            
                expect(subject).to permit(user)
            end
        end
    end
    
    describe "update?" do
        let!(:user) {create(:user)}
        
        permissions :update? do
            it "doesn't allow access when users_manage is false" do
                user.policy_group.users_index = false
                user.policy_group.users_manage = false
                user.policy_group.save!
            
                expect(subject).to_not permit(user)
            end
            
            it "doesn't allow access when users_manage is false but users_index is true" do
                user.policy_group.users_index = true
                user.policy_group.users_manage = false
                user.policy_group.save!
            
                expect(subject).to_not permit(user)
            end
            
            it "allows access when users_manage is true but users_index is false" do
                user.policy_group.users_index = false
                user.policy_group.users_manage = true
                user.policy_group.save!
            
                expect(subject).to permit(user)
            end
        end
    end
    
    describe "resend_invitation?" do
        let!(:user) {create(:user)}
        
        permissions :resend_invitation? do
            it "doesn't allow access when users_manage is false" do
                user.policy_group.users_index = false
                user.policy_group.users_manage = false
                user.policy_group.save!
            
                expect(subject).to_not permit(user)
            end
            
            it "doesn't allow access when users_manage is false but users_index is true" do
                user.policy_group.users_index = true
                user.policy_group.users_manage = false
                user.policy_group.save!
            
                expect(subject).to_not permit(user)
            end
            
            it "allows access when users_manage is true but users_index is false" do
                user.policy_group.users_index = false
                user.policy_group.users_manage = true
                user.policy_group.save!
            
                expect(subject).to permit(user)
            end
        end
    end
end
