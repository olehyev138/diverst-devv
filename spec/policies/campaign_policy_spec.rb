require 'rails_helper'

RSpec.describe CampaignPolicy, :type => :policy do

    let(:enterprise) {create(:enterprise)}
    let(:user){ create(:user, :enterprise => enterprise) }
    let(:no_access) { create(:user) }
    let(:campaign){ create(:campaign, :enterprise => enterprise)}
    let(:segments){ create_list(:segment, 10, enterprise: enterprise2) }
    let(:policy_scope) { CampaignPolicy::Scope.new(user, Campaign).resolve }
    
    subject { described_class }
    
    before {
        no_access.policy_group.manage_all = false
        no_access.policy_group.campaigns_index = false
        no_access.policy_group.campaigns_manage = false
        no_access.policy_group.campaigns_create = false
        no_access.policy_group.save!
        
        user.policy_group.manage_all = false
        user.save!
    }
    
    permissions ".scope" do
        it "shows only campaigns belonging to enterprise" do
            expect(policy_scope).to eq [campaign]
        end
    end
    
    context "when manage_all is false" do
        it "ensure manage_all is false" do
            expect(user.policy_group.manage_all).to be(false)
        end
        
        permissions :index? do
            context "when subject campaigns_index is true for user and false for no_access" do
                it "allows access" do
                    expect(subject).to permit(user, campaign)
                end
        
                it "doesn't allow access" do
                    expect(subject).to_not permit(no_access, campaign)
                end
            end
            
            context "when subject campaigns_index is false but campaigns_manage is true for user and false for no_access" do
                it "allows access" do
                    
                    user.policy_group.campaigns_index = false
                    user.policy_group.save!
                    
                    expect(subject).to permit(user, campaign)
                end
        
                it "doesn't allow access" do
                    expect(subject).to_not permit(no_access, campaign)
                end
            end
        end
        
        permissions :new? do
            context "when subject campaigns_create is true for user and false for no_access" do
                it "allows access" do
                    expect(subject).to permit(user, campaign)
                end
        
                it "doesn't allow access" do
                    expect(subject).to_not permit(no_access, campaign)
                end
            end
            
            context "when subject campaigns_create is false but campaigns_manage is true for user and false for no_access" do
                it "allows access" do
                    
                    user.policy_group.campaigns_create = false
                    user.policy_group.save!
                    
                    expect(subject).to permit(user, campaign)
                end
        
                it "doesn't allow access" do
                    expect(subject).to_not permit(no_access, campaign)
                end
            end
        end
        
        permissions :create? do
            context "when subject campaigns_create is true for user and false for no_access" do
                it "allows access" do
                    expect(subject).to permit(user, campaign)
                end
        
                it "doesn't allow access" do
                    expect(subject).to_not permit(no_access, campaign)
                end
            end
            
            context "when subject campaigns_create is false but campaigns_manage is true for user and false for no_access" do
                it "allows access" do
                    
                    user.policy_group.campaigns_create = false
                    user.policy_group.save!
                    
                    expect(subject).to permit(user, campaign)
                end
        
                it "doesn't allow access" do
                    expect(subject).to_not permit(no_access, campaign)
                end
            end
        end
        
        permissions :update? do
            context "when subject campaigns_manage is true for user and false for no_access" do
                it "allows access" do
                    expect(subject).to permit(user, campaign)
                end
        
                it "doesn't allow access" do
                    expect(subject).to_not permit(no_access, campaign)
                end
            end
        end
        
        permissions :destroy? do
            context "when subject campaigns_manage is true for user and false for no_access" do
                it "allows access" do
                    expect(subject).to permit(user, campaign)
                end
        
                it "doesn't allow access" do
                    expect(subject).to_not permit(no_access, campaign)
                end
            end
        end
    end
    
    context "when manage_all is true" do
        before {
            user.policy_group.manage_all = true
            user.policy_group.campaigns_index = false
            user.policy_group.campaigns_create = false
            user.policy_group.campaigns_manage = false
            user.policy_group.save!
        }
        it "ensure manage_all is true" do
            expect(user.policy_group.manage_all).to be(true)
        end
        
        permissions :index? do
            context "when subject campaigns_index is true for user and false for no_access" do
                it "allows access" do
                    expect(subject).to permit(user, campaign)
                end
        
                it "doesn't allow access" do
                    expect(subject).to_not permit(no_access, campaign)
                end
            end
            
            context "when subject campaigns_index is false but campaigns_manage is true for user and false for no_access" do
                it "allows access" do
                    
                    user.policy_group.campaigns_index = false
                    user.policy_group.save!
                    
                    expect(subject).to permit(user, campaign)
                end
        
                it "doesn't allow access" do
                    expect(subject).to_not permit(no_access, campaign)
                end
            end
        end
        
        permissions :new? do
            context "when subject campaigns_create is true for user and false for no_access" do
                it "allows access" do
                    expect(subject).to permit(user, campaign)
                end
        
                it "doesn't allow access" do
                    expect(subject).to_not permit(no_access, campaign)
                end
            end
            
            context "when subject campaigns_create is false but campaigns_manage is true for user and false for no_access" do
                it "allows access" do
                    
                    user.policy_group.campaigns_create = false
                    user.policy_group.save!
                    
                    expect(subject).to permit(user, campaign)
                end
        
                it "doesn't allow access" do
                    expect(subject).to_not permit(no_access, campaign)
                end
            end
        end
        
        permissions :create? do
            context "when subject campaigns_create is true for user and false for no_access" do
                it "allows access" do
                    expect(subject).to permit(user, campaign)
                end
        
                it "doesn't allow access" do
                    expect(subject).to_not permit(no_access, campaign)
                end
            end
            
            context "when subject campaigns_create is false but campaigns_manage is true for user and false for no_access" do
                it "allows access" do
                    
                    user.policy_group.campaigns_create = false
                    user.policy_group.save!
                    
                    expect(subject).to permit(user, campaign)
                end
        
                it "doesn't allow access" do
                    expect(subject).to_not permit(no_access, campaign)
                end
            end
        end
        
        permissions :update? do
            context "when subject campaigns_manage is true for user and false for no_access" do
                it "allows access" do
                    expect(subject).to permit(user, campaign)
                end
        
                it "doesn't allow access" do
                    expect(subject).to_not permit(no_access, campaign)
                end
            end
        end
        
        permissions :destroy? do
            context "when subject campaigns_manage is true for user and false for no_access" do
                it "allows access" do
                    expect(subject).to permit(user, campaign)
                end
        
                it "doesn't allow access" do
                    expect(subject).to_not permit(no_access, campaign)
                end
            end
        end
    end
end
