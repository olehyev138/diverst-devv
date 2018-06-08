require 'rails_helper'

RSpec.describe UserPolicy, :type => :policy do
    
    subject { described_class }
    
    context "when global_settings_manage is false" do
        let(:user){ create(:user) }
        let(:no_access) { create(:user) }
        
        before {
            no_access.policy_group.users_manage = false
            no_access.policy_group.save!
        }
    
        permissions :show?, :update?, :access_hidden_info? do
            it "allows access" do
                expect(subject).to permit(user, user)
            end
            
            it "doesn't allow access" do
                expect(subject).to_not permit(no_access, user)
            end
        end
    end
    
    context "when global_settings_manage is true" do
        let(:user){ create(:user) }
        let(:no_access) { create(:user) }
        
        before {
            no_access.policy_group.users_index = false
            no_access.policy_group.users_manage = false
            no_access.policy_group.save!
        }
    
        permissions :index?, :create?, :resend_invitation?, :destroy? do
            it "allows access" do
                expect(subject).to permit(user)
            end
            
            it "doesn't allow access" do
                expect(subject).to_not permit(no_access)
            end
        end
    end
end
