require 'rails_helper'

RSpec.describe UserPolicy, :type => :policy do
    let(:policy_group){ create(:policy_group, :global_settings_manage => false)}
    let(:user){ create(:user, :policy_group => policy_group) }
    let(:no_access) { create(:user) }
    
    subject { described_class }

    permissions :show? do
        it "allows access" do
            expect(subject).to permit(user, user)
        end
        
        it "doesn't allow access" do
            expect(subject).to_not permit(user, no_access)
        end
    end
    
    permissions :resend_invitation? do
        it "doesn't allow access" do
            expect(subject).to_not permit(user, user)
        end
        
        it "doesn't allow access" do
            expect(subject).to_not permit(user, no_access)
        end
    end

    permissions :update? do
        it "allows access" do
            expect(subject).to permit(user, user)
        end
        
        it "doesn't allow access" do
            expect(subject).to_not permit(user, no_access)
        end
    end

    permissions :destroy? do
        it "doesn't allow access" do
            expect(subject).to_not permit(user, user)
        end
        
        it "doesn't allow access" do
            expect(subject).to_not permit(user, no_access)
        end
    end
end
