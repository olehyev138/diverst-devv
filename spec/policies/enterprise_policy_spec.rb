require 'rails_helper'

RSpec.describe EnterprisePolicy, :type => :policy do

    let(:enterprise) {create(:enterprise)}
    let(:user){ create(:user, :enterprise => enterprise) }
    let(:no_access) { create(:user) }

    subject { described_class }

    before {
        no_access.policy_group.sso_manage = false
        no_access.policy_group.branding_manage = false
        no_access.policy_group.manage_posts = false
        no_access.policy_group.save!
    }

    permissions :edit_auth?, :edit_fields?, :edit_mobile_fields?, :update_branding?, :edit_branding?, :restore_default_branding?, :edit_posts? do
        it "allows access" do
            expect(subject).to permit(user, enterprise)
        end

        it "doesn't allow access" do
            expect(subject).to_not permit(no_access, enterprise)
        end
    end
end
