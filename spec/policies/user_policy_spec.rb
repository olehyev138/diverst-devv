require 'rails_helper'

RSpec.describe UserPolicy, :type => :policy do
    
    subject { described_class }
    
    context "when global_settings_manage is false" do
        let(:policy_group){ create(:policy_group, :global_settings_manage => false)}
        let(:user){ create(:user, :policy_group => policy_group) }
        let(:no_access) { create(:user) }
    
        permissions :show?, :update?, :access_hidden_info? do
            it "allows access" do
                expect(subject).to permit(user, user)
            end
            
            it "doesn't allow access" do
                expect(subject).to_not permit(user, no_access)
            end
        end
    end
    
    context "when global_settings_manage is true" do
        let(:policy_group_1){ create(:policy_group, :global_settings_manage => true)}
        let(:policy_group_2){ create(:policy_group, :global_settings_manage => false)}
        let(:user){ create(:user, :policy_group => policy_group_1) }
        let(:no_access) { create(:user, :policy_group => policy_group_2) }
    
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
