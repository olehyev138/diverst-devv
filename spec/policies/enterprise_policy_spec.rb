require 'rails_helper'

RSpec.describe EnterprisePolicy, :type => :policy do

  let(:enterprise) {create(:enterprise)}
  let(:user){ create(:user, :enterprise => enterprise) }
  let(:no_access) { create(:user) }

  subject { described_class }

  before {
    no_access.policy_group.manage_all = false
    no_access.policy_group.enterprise_manage = false
    no_access.policy_group.sso_manage = false
    no_access.policy_group.diversity_manage = false
    no_access.policy_group.branding_manage = false
    no_access.policy_group.manage_posts = false
    no_access.policy_group.save!

    user.policy_group.manage_all = false
    user.policy_group.save!
  }

  context "when manage_all is false" do
    it "ensure manage_all is false" do
      expect(user.policy_group.manage_all).to be(false)
    end

    permissions :update? do
      it "allows access" do
        expect(subject).to permit(user, enterprise)
      end

      it "doesn't allow access" do
        expect(subject).to_not permit(no_access, enterprise)
      end
    end

    permissions :edit_auth? do
      it "allows access" do
        expect(subject).to permit(user, enterprise)
      end

      it "doesn't allow access" do
        expect(subject).to_not permit(no_access, enterprise)
      end
    end

    permissions :edit_fields? do
      it "allows access" do
        expect(subject).to permit(user, enterprise)
      end

      it "doesn't allow access" do
        expect(subject).to_not permit(no_access, enterprise)
      end
    end

    permissions :edit_mobile_fields? do
      it "allows access" do
        expect(subject).to permit(user, enterprise)
      end

      it "doesn't allow access" do
        expect(subject).to_not permit(no_access, enterprise)
      end
    end

    permissions :manage_posts? do
      it "allows access" do
        expect(subject).to permit(user, enterprise)
      end

      it "doesn't allow access" do
        expect(subject).to_not permit(no_access, enterprise)
      end
    end

    permissions :diversity_manage? do
      it "allows access" do
        expect(subject).to permit(user, enterprise)
      end

      it "doesn't allow access" do
        expect(subject).to_not permit(no_access, enterprise)
      end
    end

    permissions :update_branding? do
      it "allows access" do
        expect(subject).to permit(user, enterprise)
      end

      it "doesn't allow access" do
        expect(subject).to_not permit(no_access, enterprise)
      end
    end

    permissions :edit_branding? do
      it "allows access" do
        expect(subject).to permit(user, enterprise)
      end

      it "doesn't allow access" do
        expect(subject).to_not permit(no_access, enterprise)
      end
    end

    permissions :edit_pending_comments? do
      it "allows access" do
        expect(subject).to permit(user, enterprise)
      end

      it "doesn't allow access" do
        expect(subject).to_not permit(no_access, enterprise)
      end
    end

    permissions :restore_default_branding? do
      it "allows access" do
        expect(subject).to permit(user, enterprise)
      end

      it "doesn't allow access" do
        expect(subject).to_not permit(no_access, enterprise)
      end
    end
  end

  context "when manage_all is true" do
    before {
      user.policy_group.manage_all = true
      user.policy_group.enterprise_manage = false
      user.policy_group.sso_manage = false
      user.policy_group.diversity_manage = false
      user.policy_group.branding_manage = false
      user.policy_group.manage_posts = false
      user.policy_group.save!
    }

    it "ensure manage_all is true" do
      expect(user.policy_group.manage_all).to be(true)
    end

    permissions :update? do
      it "allows access" do
        expect(subject).to permit(user, enterprise)
      end

      it "doesn't allow access" do
        expect(subject).to_not permit(no_access, enterprise)
      end
    end

    permissions :edit_auth? do
      it "allows access" do
        expect(subject).to permit(user, enterprise)
      end

      it "doesn't allow access" do
        expect(subject).to_not permit(no_access, enterprise)
      end
    end

    permissions :edit_fields? do
      it "allows access" do
        expect(subject).to permit(user, enterprise)
      end

      it "doesn't allow access" do
        expect(subject).to_not permit(no_access, enterprise)
      end
    end

    permissions :edit_mobile_fields? do
      it "allows access" do
        expect(subject).to permit(user, enterprise)
      end

      it "doesn't allow access" do
        expect(subject).to_not permit(no_access, enterprise)
      end
    end

    permissions :manage_posts? do
      it "allows access" do
        expect(subject).to permit(user, enterprise)
      end

      it "doesn't allow access" do
        expect(subject).to_not permit(no_access, enterprise)
      end
    end

    permissions :diversity_manage? do
      it "allows access" do
        expect(subject).to permit(user, enterprise)
      end

      it "doesn't allow access" do
        expect(subject).to_not permit(no_access, enterprise)
      end
    end

    permissions :update_branding? do
      it "allows access" do
        expect(subject).to permit(user, enterprise)
      end

      it "doesn't allow access" do
        expect(subject).to_not permit(no_access, enterprise)
      end
    end

    permissions :edit_branding? do
      it "allows access" do
        expect(subject).to permit(user, enterprise)
      end

      it "doesn't allow access" do
        expect(subject).to_not permit(no_access, enterprise)
      end
    end

    permissions :edit_pending_comments? do
      it "allows access" do
        expect(subject).to permit(user, enterprise)
      end

      it "doesn't allow access" do
        expect(subject).to_not permit(no_access, enterprise)
      end
    end

    permissions :restore_default_branding? do
      it "allows access" do
        expect(subject).to permit(user, enterprise)
      end

      it "doesn't allow access" do
        expect(subject).to_not permit(no_access, enterprise)
      end
    end
  end
end
