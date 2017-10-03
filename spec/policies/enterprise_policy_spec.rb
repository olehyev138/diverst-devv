require 'rails_helper'

RSpec.describe EnterprisePolicy, :type => :policy do
    
    let(:policy_group){ create(:policy_group, :global_settings_manage => true)}
    let(:enterprise) {create(:enterprise, :policy_groups => [policy_group])}
    let(:user){ create(:user, :enterprise => enterprise) }
    let(:policy_group_2){ create(:policy_group, :global_settings_manage => false)}
    let(:no_access) { create(:user, :policy_group => policy_group_2) }
    
    subject { described_class }

    permissions :edit_auth?, :edit_fields?, :edit_mobile_fields?, :update_branding?, :edit_branding?, :restore_default_branding? do
        it "allows access" do
            expect(subject).to permit(user, enterprise)
        end

        it "doesn't allow access" do
            expect(subject).to_not permit(no_access, enterprise)
        end
    end
end
